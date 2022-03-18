(* Generation of Toeplitz matrices and data for design verification *)
(* Rok Zitko, March 2022 *)

(* Convert uint64 to a string of 16 hex digits *)
ToHexString64[i_Integer] := IntegerString[i, 16, 16];

(* Convert a large number into an array for uint64 parts in hex form suitable
for input to Verilog *)
tohex[x_List] := Map[ToHexString64 @ FromDigits[#, 2] &, Partition[Flatten[x], 64]];

myToeplitzMatrix[c_, r_] := Table[If[i >= j, c[[i - j + 1]], r[[j - i + 1]]], {i, Length[c]}, {j, Length[r]}];

(* r - Elements of the first row *)
(* c - Elements of the first column *)

randomcr[n_Integer, l_Integer] := Module[{c, r},
 c = Table[RandomInteger[], l];
 r = Table[RandomInteger[], n-1];
 r  =Join[{First[c]}, r];
 {c,r}
];

(* Split into 64-bit chunks *)
to64[x_Integer, len_:4] := IntegerDigits[x, 2^64, len];

(* Representation of x as a column vector of bits *)
ascol[x_Integer, n_Integer] := Transpose[{IntegerDigits[x, 2, n]}];

(* Matrix multiplication using XOR multiplication and AND for addition *)
multxor[m_List, x_List] := Module[{temp},
  temp = m.x;
  Mod[Flatten[temp], 2]
];

