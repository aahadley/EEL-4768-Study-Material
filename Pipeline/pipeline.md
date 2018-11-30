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

### Structural Hazard
Occurs when two instructions need to access a particular component, such as memory.

---

## Pipeline performance
Pipelining reduces the execution time of each instruction, but it increases the throughput (amount of work done per cycle), which results in a decreased overall execution time.