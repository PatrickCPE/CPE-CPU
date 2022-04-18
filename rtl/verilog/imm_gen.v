//                              -*- Mode: Verilog -*-
// Filename        : imm_gen.v
// Description     : generates immediate value for pc jumps
// Author          : Patrick
// Created On      : Fri Apr 15 17:21:26 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:21:26 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!


//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module imm_gen (/*AUTOARG*/ ) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input [31:0] instr_w_i;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output [31:0] imm_w_o;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------
   parameter J_TYPE = 7'b1101111, // Concatanate compare field from Op Code
      U_TYPE = 6'b010111,
      S_TYPE = 4'b0011,
      B_TYPE = 3'b011,
      I_TYPE = 2'b11;           // I Type is default Else Case

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [6:0]    opcode_r;
   reg [31:0]   imm_r;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------
   always @ (*) begin
      opcode_r = instr_w_i[6:0];

      // Comparison order is based on prio, do not modify order without checking prio
      // Sign extend all results to 32-bits
      if (opcode_r == J_TYPE) begin
      end else if ({opcode_r[6], opcode_r[4:0]} == U_TYPE) begin
         imm_r = {{12{instr_w_i[31]}}, instr_w_i[31:12]};
      end else if ({opcode_r[6], opcode_r[4], opcode_r[1:0]} == S_TYPE) begin
         imm_r = {{20{instr_w_i[31]}}, instr_w_i[31:25], instr_w_i[11:7]};
      end else if ({opcode_r[4], opcode_r[1:0]} == B_TYPE) begin
         imm_r = {{19{instr_w_i[31]}}, instr_w_i[31], instr_w_i[7], instr_w_i[30:25], instr_w_i[11:8], 1'b0};
      end else begin // I_TYPE or a don't care
         imm_r = {{20{instr_w_i[31]}}, instr_w_i[31:25]};
      end

   end

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign imm_w_o = imm_r;


 endmodule // imm_gen
