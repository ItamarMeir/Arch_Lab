# LAB2
***********************************************************************
The system module is :

*******************INPUTS:***************************************
**signal X[j] - n bit vector number 
**DetectionCode where  choose the condition that we check:
	0 - X[j-1] - X[j-2] =1
	1 - X[j-1] - X[j-2] =2
	2 - X[j-1] - X[j-2] =3
	3 - X[j-1] - X[j-2] =4

*******************OUTPUTS:***************************************
detector - 1 bit signal that set in a case thate is more than m valid series by the detection code.



********************* TOP (top.vhd`)************************************
This module is the module that wraps the entire system,

                               **** procces 1 ****
	Two FF to create X[j-1], X[j-2].

                               **** procces 2 ****
-recognize which detection rule to chek and convert him to n digit binary vector
- use the adder entity to do sum = X[j-2] + condition (to add one to detection code)
anf if the specified condition is fulfilled and the valid bit is set

                               **** procces 3 ****
heck if the valid are set and how long the valid series if it more than m the detector is set


********************* Adder (`adder.vhd`)************************************
This module performs an add operation between two - n bits vector number and a carry in - and return the sum(n bits number) and the carry out bit

********************* Package (`aux_package.vhd`)************************************
This file contains in the form of a package all the components that we would like to use throughout the laboratory.
