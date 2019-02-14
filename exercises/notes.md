# introduction

introduce myself - don't need to be too honest!
my first time teaching the course
not my course, I will be skipping sections and sometimes changing the ordering
encourage support with each other, discussion
need to choose some new times for the times I'm in China.

# examples

## example-01 : counter

p59
fails BMC because counter reg isn't initialised

## example-02 : past & f_past_valid

p65
based on same counter as p59
4 different tests. Confusing that the traces don't show faults

builds up to testid 4

## example-03 : busy counter

p78
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
