# Topics:

##  ISA:

> True / false or multiple choice about: ISA definition, classification/ comparison, alignments, big vs little endian, instruction format, fields,

###     ISA Definition:

    An ISA consists of:
    - List of all instructions 
    - The format of the instructions
    - The addressing modes.


###     ISA Classification/Comparison:

####        Accumulator:

            Accumulator architectures were common in early CPUs when it was not possible to have a lot of
            registers. The accumulator is used in all operations. It is not used anymore due to its
            rigidity and long assembly code.

            Pros:
                - Simple compiler
                - Simple hardware
            Cons:
                - Rigid
                - Restrictive in parallelism
                - Long assembly codes

####        Stack:

            Used up to 1980s. The two ALU operands are popped from the stack, and the result is pushed.
            Data from memory can be pushed to the stack and data on the stack can be popped into memory.

            Pros:
                - Simple compiler
                - Simple hardware
            Cons:
                - Restrictive in parallelism
                - Long assembly codes

####        Memory-Memory:

            No registers are used. All data is kept in the computer's main memory. slow as hecc

            Pros:
                - Variables don't have to be allocated. Easy memory management
            Cons:
                - Every operation requires multiple memory accesses. (ew)
                - Slow

####        Register-Memory:

            Operates directly on data within the memory. The ALU can take one input from the registers,
            and one from memory, or it can take both operations from the registers.

            Pros:
                - Data in memory can be accessed directly.
                - Simple compiler
                - Short code
            Cons:
                - Non-uniform instructions
                - Some instructions require many clock cycles.
                - Complex encoding

####        Load-Store:

            Sometimes called register-register achitecture, the ALU takes both inputs from the registers.
            As a result, it can't access memory directly.

            Pros:
                - Simple encoding
                - Few bits required to specify registers.
                - Uniform procesing.
            Cons:
                - Long Code
                - Every variable requires load and store instructions.

###     Big Endian vs Little Endian:

        Big Endian:
            Data type ends at the big address.

            0x012EAC34                    "ABCD"
            +----+----+----+----+       +---+---+---+---+
            | 01 | 2E | AC | 34 |       | A | B | C | D |
            +----+----+----+----+       +---+---+---+---+

        Little Endian:
            Data tyoe ends at the little address.

            0x012EAC34                  "ABCD"
            +----+----+----+----+       +---+---+---+---+
            | 34 | AC | 2E | 01 |       | D | C | B | A |
            +----+----+----+----+       +---+---+---+---+
            
###     Alignments:
###     Instruction Format:
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
####        if-else:
####        while loop:
####        for loop:

##  Single Cycle Datapath:

> Single Cycle datapath: features, restrictions, components, control signals for each instructions/ format
(original datapath)

###     Features:
###     Restrictions:
###     Components:
###     Control Signals: (and format)

##  Modifying the datapath:

> how to modify for certain instructions, just likes examples discussed in the class and in the HW3, or
highlight parts of datapath

###     (on paper)
