# Data Pipeline

## The Idea
As we know, the datapath is divided into distinct stages.  

**Fetch → Decode → Execute → Memory → Write Back**  

Withoout Pipelining, each instruction would have to go through every stage before the next instruction can begin. Instead, we can allow the next instruction to be fetched as soon as the previous instruction enters the decode stage, and so on.  

#### Example

```C
v += a;
w -= b;
x *= c;
y += d;
z -= e;
```

```asm
add $t0, $t0, $s1
sub $t1, $t1, $s2
mul $t2, $t2, $s3
add $t3, $t3, $s4
sub $t4, $t4, $s4
```

Without pipelining, and assuming one cycle per stage of the datapath, this would take 25 (5 * 5) cycles to complete. If we use pipelining, we end up with something like this:

Cycle   | IF    | ID    | EX    | MEM   | WB    | 
--------|-------|-------|-------|-------|-------|
1       | add   |       |       |       |       |
2       | sub   | add   |       |       |       |
3       | mul   | sub   | add   |       |       |
4       | add   | mul   | sub   | add   |       |
5(full) | sub   | add   | mul   | sub   | add   |
6       |       | sub   | add   | mul   | sub   |
7       |       |       | sub   | add   | mul   |
8       |       |       |       | sub   | add   |
9       |       |       |       |       | sub   |  

The pipeline is full when each stage is processing an instruction. When the pipeline is full, we can finish one instruction per clock cycle. In practice, we have to intentionally slow down the datapath to avoid certain events that could prduce incorrect results.

---

## Hazards

### Data Hazard
Occurs when an instruction requires data that hasn't been computed yet.  

#### Example

```C
x = a + b;
y = x - c;
```

```asm
add $t0, $s1, $s2
sub $s3, $t0, $s4
```

Cycle   | IF    | ID    | EX    | MEM   | WB    | 
--------|-------|-------|-------|-------|-------|
1       | add   |       |       |       |       |
2       | sub   | add   |       |       |       |
3       |       |**sub**| add   |       |       |
4       |       |       | sub   | add   |       |
5       |       |       |       | sub   |**add**|
6       |       |       |       |       | sub   |


The value of $t0 isn't updated until cycle 5, but it is read at cycle 3, so we get a wrong result.  

We can avoid this by adding a stall in the datapath. We represent this with a "nop" (no operation)

Cycle   | IF    | ID    | EX    | MEM   | WB    | 
--------|-------|-------|-------|-------|-------|
1       |  add  |       |       |       |       |
2       | *nop* |  add  |       |       |       |
3       | *nop* | *nop* |  add  |       |       |
4       |  sub  | *nop* | *nop* |  add  |       |
5       |       |**sub**| *nop* | *nop* |**add**|
6       |       |       |  sub  | *nop* | *nop* |
7       |       |       |       |  sub  | *nop* |
8       |       |       |       |       |  sub  |

### Structural Hazard
Occurs when two instructions need to access a particular component, such as memory.

#### Example

```asm
//Naming each instruction to make the diagram clearer.

lw $1, 100($0)  //A
lw $2, 200($0)  //B
lw $3, 300($0)  //C
lw $4, 200($0)  //D
```
Cycle   | IF    | ID    | EX    | MEM   | WB    |
--------|-------|-------|-------|-------|-------|
1       |   A   |       |       |       |       |
2       |   B   |   A   |       |       |       |
3       |   C   |   B   |   A   |       |       |
4       | **D** |   C   |   B   | **A** |       |
5       |       |   D   |   C   |   B   |   A   |
...     |       |       |       |       |       |

In cycle 4, D has to fetch the instruction from memory, while A needs to load a word from memory. Memory cannot be accessed by two differet components in the same clock cycle, so we end up with a structural hazard.  

We can solve this problem by having separate memories for instructions and data. Otherwise, we could use nops or forwarding.

### Control Hazard
An if-else statements are used to make branch decisions in a program. An instruction may enter the pipeline before a branch decision is made, resulting in incorrect calulations or illegal memory acesses. This is called a control hazard.

#### Example ([source](https://cseweb.ucsd.edu/~j2lau/cs141/week7.html))

```asm
  lw  $6, 0($10)
  lw  $7, 0($11)
  add $1, $2, $3
  beq $0, $1, label
  sub $2, $3, $4

label:
  or  $3, $4, $5
```

Cycle   | IF    | ID    | EX    | MEM   | WB    | 
--------|-------|-------|-------|-------|-------|
1       |  lw   |       |       |       |       |
2       |  lw   |  lw   |       |       |       |
3       |  add  |  lw   |  lw   |       |       |
4       |**beq**|  add  |  lw   |  lw   |       |
5       |  sub  |**beq**|  add  |  lw   |  lw   |
6       |  ???                                  |

At this point, we don't know which instruction to load, because the condition in beq hasn't been evaluated yet. We could solve this by stalling until the condition is evaluated, but this will have a significant performance impact, especially when working with loops.  

## Avoiding Hazards
This section will contain various strategies for avoiding hazards. Previously, we saw the use of nops, which allow instructions to wait until hazards are clear before entering the pipeline. There are smarter ways to deal with hazards that will greatly speed up the pipeline.

### Forwarding
The pipeline contains a set of registers at each stage called pipeline registers. In the case of data hazards, instead of waiting for a result to be written to the cache, we could take that result directly from the pipeline registers.  

To do this, a new hardware unit must be added called the forwarding unit. If a hazard is detected, it switches a multiplexor, which causes the ALU to take its input from the pipeline register, rather than the register file.

### Reordering Instructions
- The order of two consecutive instructions can be swapped when neither uses the result of the other.

#### Example

```asm
lw $t1, 4($s4)
and $s5, $s6, $s0
```
and does not depend on the result of lw, so these **can** be swapped.

#### Example

```asm
add $t0, $t1, $t2
sub $t3, $t0, $t4
```
sub depends on the result of add ($t0), so these **cannot** be swapped.  


- However, instructions can't be swapped if they write to the same register.

```asm
add $t0, $t1, $t2
sub $t0, $t3, $t4
```
Both of these write to $t0, so they can't be swapped.

---

## Control Hazards and Branch Prediction

Returning to a previous example,  

```asm
  lw  $6, 0($10)
  lw  $7, 0($11)
  add $1, $2, $3
  beq $0, $1, label
  sub $2, $3, $4

label:
  or  $3, $4, $5
```

Cycle   | IF    | ID    | EX    | MEM   | WB    | 
--------|-------|-------|-------|-------|-------|
1       |  lw   |       |       |       |       |
2       |  lw   |  lw   |       |       |       |
3       |  add  |  lw   |  lw   |       |       |
4       |**beq**|  add  |  lw   |  lw   |       |
5       |  sub  |**beq**|  add  |  lw   |  lw   |
6       |  ???                                  |

Instead of stalling clock cycle 6, and waiting for the condition to be evaluated, we could make a prediction about the condition, and proceed according to that prediction. If the prediction was correct, yay us! Otherwise discard the result and recalculate.  

But how do we predict which branch to take without evaluating the instruction?  

### Evaluate Branch in ID stage
  - With this approach, we add a comparator to the ID stage, so that beq instructions can be evaluated right away.
  - This also requires that we add a forwarding unit to the ID stage.
  - This doesn't completely eliminate stalls, because there's still the chance of a data dependency in the branch instruction.

### Delay Slots
Another option is to move useful instructions below the branch.  

  - This requires that the pipeline structure must be encoded into the ISA.
  - This also requires that an instruction above the branch  

### Predict Branch Untaken
  - Assume that most branches will be untaken
  - Predict every time that the branch will be untaken
  - We will be correct most of the time, and only waste a few clock cycles whenever the branch is taken.

### Hardware Branch Prediction

#### Pattern History Table (with 1-bit counter)
In this approach, we'll create a table that directly maps each address to a single bit. Typically, we will have some fixed number of counters, and use some specified bits in the address as a hash function to determine which counter to use.  

- When a branch is taken, set its corresponding bit to 1.
- When a branch is not taken, set its corresponding bit to 0.
- At each branch, check its corresponding bit.
  - if bit == 1 predict taken
  - if bit == 0 predict not taken

This is a simple approach, but not very accurate. A more sophisticated approach might yield better results.

#### Smith Counter (n-bit counter)
Sometimes called an n-bit saturated counter, the Smith counter works similarly to the 1-bit counter.
- When a branch is taken, increment the counter.
- When a branch is not taken, decrement the counter.

- At each branch, check its corresponding counter.
  - if branch < 2<sup>n-1</sup> predict taken
  - if branch >= 2<sup>n-1</sup> predict not taken
  - This could be accomplished by simply checking the most significant bit.

*It should be noted that we never allow our counters to overflow. That is to say, adding to a counter at its maximum value will not change its value, nor will subtracting from a counter at its minimum value.*

---

## Pipeline performance
Pipelining reduces the execution time of each instruction, but it increases the throughput (amount of work done per cycle), which results in a decreased overall execution time.

