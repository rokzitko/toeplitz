CXXFLAGS=-std=c++2a -Wall -Wextra -O3

all: toeplitz count

toeplitz: toeplitz.cc
	g++ ${CXXFLAGS} $< -o $@

count: count.cc
	g++ ${CXXFLAGS} $< -o $@

clean:
	rm -f log? INPUT.dat OUT?.dat
	rm -f INPUT32.dat OUT32.dat
	rm -f y.dat y2.dat
	rm -f toeplitz count
