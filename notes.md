# introduction

introduce myself - don't need to be too honest!
my first time teaching the course
not my course, I will be skipping sections and sometimes changing the ordering
encourage support with each other, discussion
need to choose some new times for the times I'm in China.
have a break after 1 hour
zoom etiquette, mute mic

people: eric, hipolito, guillem, ma'muri

what have been my bugs?

* fifo write and write when full results in a pointer out by one
* spi client - sometimes would change temp output register while copying to data out

# p29 assume/assert question 

answer: no because assume counter will be less 90
even if no assumption - assertion would fail at 100

# p46 multiply 

multiply? where is the mulitply?
check the answer is produced from the for loop
so the intention here is that you can use techniques in the formal properties definition that you wouldn't dream of using on the fpga itself.

## p59 example-01 : counter

fails BMC because counter reg isn't initialised

## p65 example-02 : past & f_past_valid

based on same counter as p59
4 different tests. Confusing that the traces don't show faults

builds up to testid 4

# p72: difference on resets

on async design f_past_valid takes several cycles, but reset is async could be a difference.
initial assume won't work with verific (or verific enabled yosys). verific is parser system for verilog, systemverilog and vhdl

## p78 example-03 : busy counter (homework for session 1)

2 parts:

// #1, To Prove:
//	1. Assume that once raised, i_start_signal will remain high until it
//		is both high and the counter is no longer busy.
//		Following (i_start_signal)&&(!o_busy), i_start_signal is no
//		longer constrained--until it is raised again.
//	2. o_busy will *always* be true any time the counter is non-zero.
//	3. If the counter is non-zero, it should always be counting down

fairly straight forwards

and

// #2, To Prove:
//	1. First, adjust o_busy to be a clocked signal/register
//	2. Prove that it will only ever be true when the counter is non-zero

need to rearrange clocked block to ensure busy flag is set correctly
can introduce cover here?

# K-induction - p80

# p84:

what are the set symbols?

upside down A means 'for all'
P is a function that is true or false. n at which timestep is it true/false
A with no cross bar AND

shows that induction will always pass the first x steps and fail on the last.

# p86 general kinduction

* always fail on last step
* when would you get no trace? warmup failure - when your assumptions are contradactory

# p89:

checkers example?
good answers on page 90, but mostly a fun way to see that k induction can start your design in crazy ways

# p97:

shift reg fix i_ce
i_ce assumed?
what is share-all opt_merge - merges identical cells.

# p103 example-04 : dblpipe , opt-merge:

I need i_ce assumed, so that registers get filled?
change engine to  abc pdr "fixes" with no assume(i_ce)
OR force no more than 2 clocks between i_ce

OR force no more than 2 clocks between i_ce AND increase steps to 22
add engine to abc pdr also works with steps 12, how to remove smtbmc for induction?

# p105 example-05 : lfsrs prove equivalence

need to do same as in exercise 04

# p106:

a problem == your design is doing something odd/unexpected/unwanted.

# p124: exercise 6 - simpler arbiter

# p127: exercise 7 - wishbone bus arbiter (homework)

## QUESTIONS

pls check my exercise 6

# p121:

solves i_ce problem? isnt' i_ce probelm about ensuring things become synchronised?

# p122:

? what is the problem. my guess is timing on the ack vs req

# p137:

problems with multiple files.

# p143: 

prefetch so what?

p145, f_value should be f_data?

# p147:

cache implementation
what 3 properties?

# p224:

how is the assert worked out that way? doesn't make sense?

# p239:

clock switching?
