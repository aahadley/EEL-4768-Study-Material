# Topics:

##  ISA:

> True / false or multiple choice about: ISA definition, classification/ comparison, alignments, big vs little endian, instruction format, fields,

###     ISA Definition:

#### An ISA consists of:
* List of all instructions 
* The format of the instructions
* The addressing modes.

###     ISA Classification/Comparison:

####        Accumulator:

</p> Accumulator architectures were common in early CPUs when it was not possible to have a lot of registers. The accumulator is used in all operations. It is not used anymore due to its rigidity and long assembly code. </p>

##### Pros:
* Simple compiler
* Simple hardware
##### Cons:
* Rigid
* Restrictive in parallelism
* Long assembly codes


![ac](https://puu.sh/BEJ3e/e7b098f53e.png)

####        Stack:

</p> Used up to 1980s. The two ALU operands are popped from the stack, and the result is pushed. 
Data from memory can be pushed to the stack and data on the stack can be popped into memory. </p>

##### Pros:
* Simple compiler
* Simple hardware
##### Cons:
* Restrictive in parallelism
* Long assembly codes


![st](https://puu.sh/BEJ3M/fed3ce44b7.png)

####        Memory-Memory:

</p> No registers are used. All data is kept in the computer's main memory. slow as hecc </p>

##### Pros:
* Variables don't have to be allocated. Easy memory management
##### Cons:
* Every operation requires multiple memory accesses. (ew)
* Slow

####        Register-Memory:

</p> Operates directly on data within the memory. The ALU can take one input from the registers, and one from memory, or it can take both operations from the registers. </p>

##### Pros:
* Data in memory can be accessed directly.
* Simple compiler
* Short code
##### Cons:
* Non-uniform instructions
* Some instructions require many clock cycles.
* Complex encoding

![rm](https://puu.sh/BEJ4i/093b34401e.png)

####        Load-Store:

</p> Sometimes called register-register achitecture, the ALU takes both inputs from the registers.As a result, it can't access memory directly. </p>

##### Pros:
* Simple encoding
* Few bits required to specify registers.
* Uniform procesing.
##### Cons:
* Long Code
* Every variable requires load and store instructions.

![ls](https://puu.sh/BEJ4Y/5f242b7fd6.png)

###     Big Endian vs Little Endian:

####        Big Endian:
            Data type ends at the big address.

            0x012EAC34                    "ABCD"
            +----+----+----+----+       +---+---+---+---+
            | 01 | 2E | AC | 34 |       | A | B | C | D |
            +----+----+----+----+       +---+---+---+---+

####        Little Endian:
            Data type ends at the little address.

            0x012EAC34                  "ABCD"
            +----+----+----+----+       +---+---+---+---+
            | 34 | AC | 2E | 01 |       | D | C | B | A |
            +----+----+----+----+       +---+---+---+---+

###     Alignments:

* Objects larger than 1 byte must be aligned.
* An access to an object s at address A is aligned if A mod s = 0.
* Misalignment is a problem because accessing a misaligned object may require access to multiple aligned addresses.


![fig](https://puu.sh/BEIJt/e36308fc1f.jpg)

###     Instruction Format:
####        R-Type:
####        I-Type
####        J-Type

###     Fields:

##  Architectures: (translating expressions to assembly)

> translate certain expression that includes variables and operations into assembly of one of
architecture, i.e. load-store, or register-memory, stack etc., instructions will be provided in random order.

###     Load-Store:
###     Register-Memory:
###     Stack:
###     ...

##  MIPS 64:

> translate C-like code into MIPS64 , C code can be if - else statement , or for loop, addresses of variables
will be included, in addition to the list of MIPS64 instructions.

###     Translate c-like code into MIPS64:
####        Comparing Floats

```C
|a2 – b| < epsilon
```

```assembly
.data
a:      .float 0.1
b:      .float 0.01
e:      .float 1.0e-7

.text
# load the addresses of variables into registers
LA      R1, a
LA      R2, b
LA      R3, e

# load into FPRs (single precision)
L.S     F0, 0(R1)
L.S     F1, 0(R2)
L.S     F2, 0(R3)

MUL.s   F0, F0, F0
SUB.S   F3, F0, F1
ABS.S   F3, F3
C.LT.S  F3, F2
BC1F    not_quite

...

not_quite
```

    Convert a floating point value to an integer,
    Add it to an integer register

```assembly
cvt.w.s F31, F0
mfc1    R2, F31
add     R3, R1, R2
```

####        Working with Double Words
```C
// Load the 64-bit number 0x11223344 AABBCCDD to n.

__int64_t n = 0;    // equivalent to long long in UNIX, used for specificity
n = 0x11223344AABBCCDD
```

```assembly
# x represents a garbage value
.data
n:      .word 0

.text

...

LUI     R1, 0x1122          # R1 = xxxx xxxx 1122 0000
ORI     R1, R1, 0x3344      # R1 = xxxx xxxx 1122 3344
DSLL32  R1, R1, 32          # R1 = 1122 3344 0000 0000
LUI     R2, 0xAABB          # R2 = xxxx xxxx AABB 0000
ORI     R2, R2, OxCCDD      # R2 = xxxx xxxx AABB CCDD
DSLL32  R2, R2, 32          # R2 = AABB CCDD 0000 0000
DSRL32  R2, R2, 32          # R2 = 0000 0000 AABB CCDD

                            # R1 = 1122 3344 0000 0000  no change, just showing the values together
                            # R2 = 0000 0000 AABB CCDD

OR      R1, R1, R2          # R1 = 1122 3344 AABB CCDD
LA      R30, n
SD      R1, 0[R30]          # store R1 at the address of n (syntax highlighting wants brackets, idk)
```

####        Floating Point Arithmetic
```C
__int64_t a, b, c;
float avg;

avg = (float) (a + b + c) / 3;
```

```assembly
.data
a:  .word  ... @1000
b:  .word  ... @1008
c:  .word  ... @1016
avg .float ... @2000

.text
LD      R1, 1000(R0)    # load a
LD      R2, 1008(R0)    # load b
LD      R3, 1016(R0)    # load c
DADD    R4, R1, R2      # double word add
DADD    R4, R4. R3
MTC1    R4, F0          # move the sum to FPR
CVT.s.L F0, F0          # convert to single precision
LI.S    F1, 3
DIV.S   F2, F0, F1
S.S     F2, 2000(R0)
```

####        if-else:
```C
__int64_t a, b, f;

if(A == 0 && B == 25)
    f = a + b
```

```assembly
.data
a:  .word ... @800
b:  .word ... @808
f:  .word ... @816

.text
LD      R1, 800(R0)     # R1 <-- a
BNE     R1, R0, Exit    # If a != 0 , exit
LD      R2, 808(R0)     # R2 <-- B
DADDI   R3, R0, 25      # R3 <-- 25
BNE     R2, R3, Exit    # if b != 25 , exit
DADD    R4, R1, R2
SD      R4, 816(R0)     # f <- R4

Exit:
``` 

####        for loop:
```C
__int64_t a[100];   // a at 2400
__int64_t b[100];   // b at 4800
__int64_t c, i;     // c at 1000, i at 1200

for(i = 0; i < 100; i++)
    a[i] = b[i] + c;
```

```assembly
.text

DADD    R1, R0, R0      # R1 := i = 0
LD      R2, 1000(R0)    # R2 <-- C

Loop:
DSLL    R3, R1, 3       # R3 = i * 8
DADDI   R4, R3, 2400    # R4 = 8i + &a = a[i]
DADDI   R5, R3, 4800    # R5 = 8i + &b = b[i]
LD      R6, 0(R5)       # R6 <-- b[i]
DADD    R6, R6, R2      # R6 = b[i] + c
SD      R6, 0(R4)       # a[i] <-- R6 = b[i] + c
DADDI   R1, R1, 1       # i++
DADDI   R7, R1, -100    # used to check that the counter has reached 100
BNEZ    R7, Loop        # if R7 != 0, branch to loop
SD      R1, 1200(R0)    # i <-- R1
```


####        while loop:

##  Single Cycle Datapath:

> Single Cycle datapath: features, restrictions, components, control signals for each instructions/ format
(original datapath)

![dp](https://puu.sh/BERqv/5b58a49b12.png)

###     Features:

* simple implementation
* each instruction takes one clock cycle

###     Restrictions:

* No parallelism
* slooow

###     Components:
###     Control Signals: (and format)

![cs](https://puu.sh/BERp1/af1bfffa9d.png)

##  Modifying the datapath:

> how to modify for certain instructions, just likes examples discussed in the class and in the HW3, or
highlight parts of datapath

###     (on paper)
