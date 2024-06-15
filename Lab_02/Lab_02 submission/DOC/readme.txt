LAB2
***********************************************************************
The system module is:

INPUTS:
- signal X[j] - n bit vector number
- DetectionCode where choose the condition that we check:
  - 0 - X[j-1] - X[j-2] = 1
  - 1 - X[j-1] - X[j-2] = 2
  - 2 - X[j-1] - X[j-2] = 3
  - 3 - X[j-1] - X[j-2] = 4

OUTPUTS:
- detector - 1 bit signal that is set in a case that there are more than m valid series by the detection code.

TOP (top.vhd`)
This module is the module that wraps the entire system,

  **** process 1 ****
  Two FF to create X[j-1], X[j-2].

  **** process 2 ****
  - Recognize which detection rule to check and convert it to an n-digit binary vector.
  - Use the adder entity to perform the sum = X[j-2] + condition (to add one to the detection code) and if the specified condition is fulfilled and the valid bit is set.

  **** process 3 ****
  Check if the valid bits are set and how long the valid series is. If it is more than m, the detector is set.

Adder (`adder.vhd`)
This module performs an add operation between two n-bit vector numbers and a carry-in, and returns the sum (n-bit number) and the carry-out bit.

Package (`aux_package.vhd`)
This file contains, in the form of a package, all the components that we would like to use throughout the laboratory.
