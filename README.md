# Toeplitz entropy extractor

This is an implementation of Toeplitz entropy extractor for algorithmic post-processing of
raw bitstreams from entropy sources in random number generators. This technique increases
the min-entropy of the bit stream at the cost of lower bitrate (i.e., it performs compression). 
The same approach is also applicable to privacy amplification in quantum key distribution.

The repository contains several implementations:

 * Verilog version for hardware implementation on field programmable gate arrays (FPGAs).
 * C++ version for execution on CPUs.
 * Mathematica Notebook version for testing and validation purposes.

These codes were created in the scope of a Target research programme (Ciljni raziskovalni
programi, CRP) V1-2119 "Cryptographically secure random number generator", funded
by UVTP and ARRS, Slovenia.

## Contact information:

   [Project home page](https://www.ijs.si/ijsw/ARRSProjekti/2021/Kriptografsko%20varen%20generator%20naklju%C4%8Dnih%20%C5%A1trevil)

```
   Rok Zitko
   "Jozef Stefan" Institute
   F1 - Theoretical physics
   Jamova 39
   SI-1000 Ljubljana
   Slovenia

   rok.zitko@ijs.si
```
