CXXFLAGS=-std=c++2a -Wall -Wextra -O3

all: toeplitz count

toeplitz: toeplitz.cc
	g++ ${CXXFLAGS} $< -o $@

count: count.cc
	g++ ${CXXFLAGS} $< -o $@

clean:
	rm -f log? INPUT.dat OUT?.dat
	rm -f INPUT32.dat INPUT32x.dat OUT32.dat OUT32x.dat
	rm -f INPUT64.dat INPUT64x.dat OUT64.dat OUT64x.dat
	rm -f y.dat y2.dat
	rm -f toeplitz count
