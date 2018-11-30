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

---

## Pipeline performance
Pipelining reduces the execution time of each instruction, but it increases the throughput (amount of work done per cycle), which results in a decreased overall execution time.