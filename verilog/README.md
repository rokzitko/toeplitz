# Verilog implementation of the Toeplitz extractor

## Files

- `toeplitz.nb` - Mathematica notebook for generating the reference data for testing (same matrix as in `../c++`)
- `toeplitz.m` - key mathematica functions for generating Toeplitz matrices (for running from command line)
- `toeplitz.sv` - serial version of Toeplitz extractor
- `toeplitz_p.sv` - parallel version of Toeplitz extractor
- `c64-hex.dat`, `r64-hex.dat`, `rr64-hex.dat` - hex representatio of the first column & row for generating the Toeplitz matrix
- `x*.dat` - test vector for testbench
- `y*.dat` - reference results for testbench
- `chunker.sv` - Split blocks of `L` bits into blocks of `M` bits
- `chunker_with_buffer.sv` - same as `chunker.sv`, but buffers the input data
- `readrc.sv` - Read row and column data from a file
- `readrc.sv.without_streaming_operators` - same as `readrc.sv`, buf without streaming operatos
- `readrc.sv.gen` - Generate readrc.sv for arbitrary `N` and `L`
- `serializer.sv` - Serialize a packed array of bits (from MSB to LSB)
- `tb_*` - testbenches
- `README.md` - this fie
