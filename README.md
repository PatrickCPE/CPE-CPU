# CPE CPU

## Overview
The CPE CPU is a softcore CPU implementing the Risk-V RV32I instruction set (with very small caveats). 

It was designed completely heirachically with a high focus on readability, and it's main purpose was for me to develop a better understanding of Computer Architecture. 


## CPE_CPU - The Design
The design is based on the microarchitecture detailed in Patterson and Hennesy's Computer Architecture and Design book with slight modifications 

TODO DRAW NICE TOP LEVEL OF THE MICRO ARCHITECTURE 

The focus here was by no means to be efficient. I mean this is a single cycle processor, it's far from efficient. The goal was simplicity, and I can make improvements from there. I saw an intersting write up on a simple two stage pipeline I may try out next :) 

## Sub Modules

### ALU
The ALU is the heart of the processor. I aimed for a rather simple version with only the basic control lines (before realizing it wasn't capable of doing a few oddball instructions and bastardizing my design, I'll make it prettier later, I promise). 

<img src="doc/block_diagrams/alu-alu.svg">

The ALU is capable of performing all of the basic arithmetic operations on the systems. The A input can come from either register output 1, or from the program counter, and the B input can either come from register output 2 or the immediate generator.

### CMP_GEN

### COND_BRANCH_CONTROL

### CONTROL

### IMM_GEN

### PC

### REGISTERS



