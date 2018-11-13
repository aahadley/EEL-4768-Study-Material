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

### Terms

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

### Direct-Mapped Cache

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
//TODO

####    Cache Size