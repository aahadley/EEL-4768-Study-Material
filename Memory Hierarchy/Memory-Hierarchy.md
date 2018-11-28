# Memory Hierarchy 
https://courses.cs.washington.edu/courses/cse378/09wi/lectures.html

## Hierarchy Overview
-   registers  
    |
-   cache  
    |
-   main memory  
    |
-   Disk

---

## The Goal of Memory Hierarchy
Capacity and speed have opposing properties. That is to say, the more memory you have in a system, the slower it is. We need to design memory that gives the *illusion* of having large capacity and fast speeds. We can do this in two ways.

-   Hierarchy  
Data at the fastest level is a subset of data at slower levels. In this way, we leverage locality to increase speed.

-   Parallelism  
Allow multiple bit access between levels

## Principle of Locality

### Temporal Locality
If a memory location is referenced, it is likely to be referenced again soon. Thus, we keep recently accessed data close to the CPU.

### Spacial Locality
If a memory location is referenced, it will tend to be referenced again soon. Thus, we move blocks of *contiguous words* closer to the CPU. 

## Overall Strategy
-   Store everything on disk
-   Copy recently accessed, and nearby items to DRAM.
-   Copy recently accessed, and nearby items to SRAM(cache)

---

## Terms

### Block
A unit of copying consisting of one or more words.

### Hit
Access satisfied by upper level

### Miss
Access not satisfied by upper level, block copied from lower level.

### Miss Penalty
Time taken to copy memory after a miss.

---

## Cache Memory
https://courses.cs.washington.edu/courses/cse378/09wi/lectures/lec15.pdf  
The level of memory closest to CPU

## Direct-Mapped Cache

\<image\>

Cache location determined by (address *mod* cacheSize)
Due to the properties of division over integers mod 2, we can compute its location by taking the least significant bits of the address.  

First, we need to know that the cache doesn't contain garbage data. To do this, we assign a single *valid bit* to each cache block. We initialize these to zero, and flip them when the first address is inserted.  

Now we can use the rest of the address bits, called the *tag* to determine if the address is already in the cache.

\<image\>

\<example\>

####    On cache hit
-   The address is sent to a cache controller when the CPU reads from memory. 
-   The lowest bits of the address will access the cache.
-   Valid bit: 1
-   tag == address[m - k]

####    On cache miss
-   The address is sent to a cache controller when the CPU reads from memory. 
-   The lowest bits of the address will access the cache.
-   valid bit == 0 || tag != address[m - k]
-   The address is then fetched from main memory and copied to the cache.

####    Replacement Policies
What happens when the cache fills up? We have to overwrite something, but what?

#####   LRU - Least Recently Used
The least recently used address is evicted first. This is helpful because recently used addresses are likely to be accessed again soon.

#####   FIFO - First In First Out
Each set acts as a queue. The first address placed in the queue will be evicted first.

#####   Random
Self explanatory. Just pick a random block to evict.

####    Location Within the Cache

For an m-bit address:

            (m-k-n) bits         k bits   n bits
    +--------------------------+---------+------+
    |            Tag           |  Index  |Offset|
    +--------------------------+---------+------+

    where n is the number of bits required to enumerate each byte in a block,
          k is the number of bits required to enumerate each block.

Offset:     address *mod* 2<sup>n</sup>  

Index:      (address / 2<sup>n</sup>) *mod* 2<sup>k</sup>  

Tag:        address / m

Number of bits in the cache:  (number of blocks) * [(Valid bit) + (tag) + (data)] 

##### Example:

32 bit address:

    +------------------------+------+--+
    |            24          |  6   |2 |
    +------------------------+------+--+

    4 bytes per block, so n = 2.  
    64 blocks, so k = 6  
    32 - 6 - 2 = 24.  

## Associative Caches

### Fully Associative
Data can be stored in any cache block. This eliminates collisions, but requires a comparator for every entry. This is expensive and usually impractical.

<image slide 43>
https://courses.cs.washington.edu/courses/cse378/09wi/lectures/lec15.pdf

### n-way Set Associative
The cache is divided into sets, each set consists of n blocks.

<image>

#### Locating a set associative block
block offset    = address *mod* 2<sup>n</sup>
block address   = address / 2<sup>n</sup>
set index       = block address mod 2<sup>s</sup>

#### Example
Find the location of 0x1833<sub>16</sub> = 00...01 1000 0011 0011<sub>2</sub>.
Assume 8-block cache, with 16 bytes per block.

The lowest three bytes, **0011**<sub>2</sub> = 3<sub>10</sub>

##### 1-way
8 sets, so we need 3 bits to index each set.  
Thus, the next 3 bits are the set index. **011**

##### 2-way
4 sets, so the next 2 bits are the set index. **11**

##### 4-way
2 sets, so the next bit is the set index. **1**

<image>

#### Considerations
- Increased Associativity decreases miss rate, but with diminishing returns.
- Miss rate is not a good metric for evaluating performance, because it fails to consider hit time and miss penalty.
- Instead, we use Average Memory Access Time.
- AMAT = Hit Time + Miss Rate * Miss Penalty.

## Multilevel Caches

In order to make the most of this tradeoff, we use multiple levels of cache, so each level can optimize one performance factor.

- Level 1 is small with low associativity. Hit Time is minimized.
- Level 2 is large with high associativity. Miss Rate is minimized.
- Level 3 is even larger with high associativity. Older systems might not have an L3 cache.

#### Example
//TODO

---

### Cache Misses
A cache miss happens when an access is attempted, but not found in the cache.  

#### Sources of Cache Misses

##### Compulsory
##### Capacity
##### Collision Conflict

### Write-Policy
#### Write-Through
- On hit, update the block in cache, and update memory
- This is slow, so we typically use a write buffer to reduce the number of writes.

#### Write-Back
- On hit, update the block in cache, and keep track of each block's *dirty bit.*
- When a block is replaced, write it to memory.

---

## Measuring Cache Performance

**AMAT = Hit Time + Miss Rate * Miss Penalty**

#### Example
A CPU has a 
- Clock rate = 1ns
- Hit time = 1 Cycle
- Miss penalty = 20 cycles
- Instruction Cache miss rate = 5%

AMAT = (1.0E-9 s) + (0.05 s/cycle)(20 cycles) = 2ns

#### Example
//TODO

### Performance Summary
- Increased CPU performance => More significant miss penalty
- Decreased base CPI        => Greater proportion of time spent on stalls
- Increased clock rate      => More CPU cycles per memory stall

---

## Virtual Memory

- Main memory is used as a cache for hard disk storage.  
- Each program is allocated a private virtual address space.  
- The CPU and OS work together to translate virtual addresses to physical addresses.
- A **page** in virtual memory is analogous to a cache block.
- A **page fault** is analogous to a cache miss.

### Address Translation
Pages in virtual memory are indexed by a **page table**.

- Each process has a separate page table, pointed to by the **page table register** in the CPU.
- Page tables are indexed by virtual page numbers
- Each entry contains a valid bit, and a **physical page number**. By concatenating the PPN and the page offset, we obtain the physical address.

### Page Table Size Example
32-bit address, 4KiB pages, 4 bytes per page table entry.  
(4KB = 2<sup>12</sup> bytes)

number of entries = 2<sup>32</sup> / 2<sup>12</sup> = 2<sup>20</sup>.  

Table Size = number of entriess * size of entry = 2<sup>20</sup> * 4 = 2<sup>22</sup> = 4MiB.

### Translation Lookaside Buffer (TLB)
The TLB is used to speed up the translation process.

<image>