VHDL Project Files Overview
This project contains various VHDL files necessary for designing a digital system. Below is an explanation of each file:

Adder

This file implements an adder module, used for arithmetic operations within the datapath.
ALU

The Arithmetic Logic Unit (ALU) is responsible for performing arithmetic and logical operations.
aux_package

A package file that contains auxiliary functions, types, and constants used throughout the project.
BidirPin

Implements a bidirectional pin, which can be used for data input and output.
ControlUnit

The control unit file defines the control logic, generating control signals based on the instruction set and current state.
dataMem

Represents data memory, used to store and retrieve data during execution.
Datapath

The datapath file connects various functional units (like ALU, registers) and handles data flow within the processor.
FA

Could be an abbreviation for a full adder, used for single-bit addition operations.
OPC_decoder

Opcode decoder, which interprets the opcode from the instruction and generates corresponding control signals.
PC

The program counter, which keeps track of the current instruction address.
progMem

Program memory, where the instructions for the processor are stored.
register

Defines a register used for temporary data storage during operations.
registerMS

 a special type of register, possibly a multi-stage register for pipelined operations.
RF

Register file, which contains multiple registers and provides read/write access to them.
Rfadder

Possibly a specialized register file adder, used within the register file for specific addition operations.
top

The top-level file of the project. It integrates all the components and defines the main architecture and entity of the system.