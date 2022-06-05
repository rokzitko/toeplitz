toeplitz - C++ implementation of Toeplitz extractor (privacy amplification)

This tool computes y=m.x, where m is an l x n Toeplitz matrix, x is a dimension n input vector,
and y is a dimension l output vector.

The input is expected to be given in blocks of BS=64 bits (uint64_t), thus n and l need to be
multiples of 64.

Command line switches:

-v - enables verbose mode
-n, -l - dimensions
-r, -c - read the matrix in the form of first-row and first-column elements (bit per bit)
-m - read the matrix in the form of a full matrix (in blocks of 64 bits as decimal numbers, row by row)
-R - generate a random Toeplitz matrix with dimensions l x n
-i, -o - input and output file name

If the input and output files are not specified, the tool reads standard input and output.

Note that in transforming bit arrays into uint64_t, the most-significant bit comes first.

The tool comes with a test script and reference results to check the validy of the calculation.
There is also a Mathematica notebook which generates the reference data.

Files:

toeplitz.cc - source code of the tool
count.cc - source code of a generator of sequences for testing purposes
toeplitz.nb - Mathematica notebook for generating reference results
c.dat, r.dat: random values for columns and rows for matrix m
m64.dat: explicit matrix representation of m, in the form of 64bit integers
x.bin - test vector
y.bin - test result
test - runs tests: produces no output if all tests pass
OUT.ref, OUT32.ref - reference results for counter test
Makefile - make file for building tools & cleaning up
README.md - this file
