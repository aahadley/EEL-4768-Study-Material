set -e
# Unofficial test script for project 1:
# EEL 4768
# Fall 2018
# Aaron Hadley

printf "**NOTE**\n I'm just some dude. I make mistakes, and I didn't spend
a lot of time on this.
You should verify for yourself that this script is correct, \
and that you're testing the right things.\n"

gcc sim.c -o SIM

#./SIM 32768 8 0 1 testinput.t

# ./SIM <CACHE_SIZE> <ASSOC> <REPLACEMENT> <WB> <TRACE_FILE>
#
# <CACHE_SIZE>      is the size of the simulated cache in bytes
# <ASSOC>           is the associativity
# <REPLACEMENT>     replacement policy: 0 means LRU,           1 means FIFO
# <WB>              Write-back policy:  0 means write-through, 1 means write-back
# <TRACE_FILE>      trace file name with full path

# Test A:
# Use the MiniFE and XSBench provided traces to analyze how the miss ratio of these
# workloads changes with cache size. Fix cache associativity at 4, write-back,
# replacement policy to be LRU, and vary the cache size from 8KB to 128KB in multiples
# of 2, i.e., 8KB, 16KB... 128KB.

printf "Compiled successfully! Beginnig tests...\n\n\n"

printf "\n============================================================="
printf "\n=============================================================\n\n"
printf "\n                Test A: Cach Size Comparisons\n"
printf "\n============================================================="
printf "\n=============================================================\n\n"


printf "\n------------------------------"
printf "\n       Testing XSBench\n"
printf "\n------------------------------\n\n"

i=8192
while [ $i -le 256000 ]
do
    echo ; echo Testing XSBench at $i bytes. ; printf "\n" 
    ./SIM $i 4 0 1 XSBENCH.t
    ((i=i*2)) 
done

echo Finished Test A: XSBench.

printf "\n------------------------------"
printf "\n       Testing XSBench\n"
printf "\n------------------------------\n\n"

i=8192
while [ $i -le 256000 ]
do
    echo ; echo Testing MINIFE at $i bytes. ; printf "\n" 
    ./SIM $i 4 0 1 MINIFE.t
    ((i=i*2)) 
done

echo Finished Test A: XSBench.


printf "\n*************************************************************\n"
printf "\n                Test A Complete!\n"
printf "\n*************************************************************\n\n"


# Test B: 
# Similar to part A, but change write policy and compare between write-back and write-
# through for each cache size by using the number of memory reads and writes.

printf "\n============================================================="
printf "\n=============================================================\n\n"
printf "\n                Test B: Write Mode Comparisons\n"
printf "\n============================================================="
printf "\n=============================================================\n\n"

printf "\n------------------------------"
printf "\n       Testing XSBench\n"
printf "\n------------------------------\n\n"

i=8192
while [ $i -le 256000 ]
do
    echo ; echo Testing XSBench at $i bytes. ; printf "\n" 
    ./SIM $i 4 0 0 XSBENCH.t
    ((i=i*2)) 
done

echo Finished Test B: XSBench.

printf "\n------------------------------"
printf "\n       Testing MINIFE\n"
printf "\n------------------------------\n\n"

i=8192
while [ $i -le 256000 ]
do
    echo ; echo Testing MINIFE at $i bytes. ; printf "\n" 
    ./SIM $i 4 0 0 MINIFE.t
    ((i=i*2)) 
done

echo Finished Test B: MINIFE.

printf "\n*************************************************************\n"
printf "\n                Test B Complete!\n"
printf "\n*************************************************************\n\n"



# Test C: 
# Similar to part A, but instead of varying the cache size change the associativity. Fix the
# replacement policy to be LRU, cache size to be 32KB, associativity to change from 1
# to 64, in multiples of 2, e.g., 1, 2, 4... 64.

printf "\n------------------------------"
printf "\n       Testing XSBench\n"
printf "\n------------------------------\n\n"

i=1
while [ $i -le 64 ]
do
    echo ; echo Testing XSBench at $i-way associativity. ; printf "\n" 
    ./SIM 32768 $i 0 1 XSBENCH.t
    ((i=i*2)) 
done

echo Finished Test C: XSBench.

printf "\n------------------------------"
printf "\n       Testing MINIFE\n"
printf "\n------------------------------\n\n"

i=1
while [ $i -le 64 ]
do
    echo ; echo Testing MINIFE at $i-way associativity. ; printf "\n" 
    ./SIM 32768 $i 0 1 MINIFE.t
    ((i=i*2)) 
done

echo Finished Test C: MINIFE.

printf "\n*************************************************************\n"
printf "\n                Test C Complete!\n"
printf "\n*************************************************************\n\n"



# Test D
# Similar to part C, but now study the impact of replacement policy. Specifically, run the
# same experiments you ran in part C, but with FIFO replacement policy, write-back,
# then compare the results of part C and D to study the impact of replacement policy
# changes with associativity.

printf "\n============================================================="
printf "\n=============================================================\n\n"
printf "\n          Test D: Replacement Policy Comparisons\n"
printf "\n============================================================="
printf "\n=============================================================\n\n"


printf "\n------------------------------"
printf "\n       Testing XSBench\n"
printf "\n------------------------------\n\n"

i=1
while [ $i -le 64 ]
do
    echo ; echo Testing XSBench at $i-way associativity. ; printf "\n" 
    ./SIM 32768 $i 1 1 XSBENCH.t
    ((i=i*2)) 
done

echo Finished Test D: XSBench.

printf "\n------------------------------"
printf "\n       Testing MINIFE\n"
printf "\n------------------------------\n\n"

i=1
while [ $i -le 64 ]
do
    echo ; echo Testing MINIFE at $i-way associativity. ; printf "\n" 
    ./SIM 32768 $i 1 1 MINIFE.t
    ((i=i*2)) 
done

echo Finished Test D: MINIFE.

printf "\n*************************************************************\n"
printf "\n                Test D Complete!\n"
printf "\n*************************************************************\n\n"

printf "All tests complete. Best of luck on your report!\n-Aaron\n\n"

printf "**NOTE**\n I'm just some dude. I make mistakes, and I didn't spend
a lot of time on this.
You should verify for yourself that this script is correct, \
and that you're testing the right things.\n"