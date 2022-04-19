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
module imm_gen (/*AUTOARG*/
   // Outputs
   imm_w_o,
   // Inputs
   instr_w_i
   ) ;

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
      S_TYPE = 7'b0100011,
      B_TYPE = 7'b1100011,
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
   reg [2:0]    expected_value_reg;
   always @ (*) begin
      opcode_r = instr_w_i[6:0];
      expected_value_reg = {opcode_r[3], opcode_r[1:0]};

      // Comparison order is based on prio, do not modify order without checking prio
      // Sign extend all results to 32-bits
      if (opcode_r == J_TYPE) begin
         imm_r = 4;             // TODO
      end else if ({opcode_r[6], opcode_r[4:0]} == U_TYPE) begin
         imm_r = {instr_w_i[31:12], {12{1'b0}}};
         //imm_r = 3;             // TODO
      end else if (opcode_r == S_TYPE) begin
         imm_r = {{20{instr_w_i[31]}}, instr_w_i[31:25], instr_w_i[11:7]};
         imm_r = 2;             // TODO
      end else if (opcode_r == B_TYPE) begin
         imm_r = {{19{instr_w_i[31]}}, instr_w_i[31], instr_w_i[7], instr_w_i[30:25], instr_w_i[11:8], 1'b0};
         imm_r = 1;             // TODO
      end else begin // I_TYPE or a don't care
         imm_r = {{20{instr_w_i[31]}}, instr_w_i[31:20]};
         imm_r = 0;             // TODO
      end

   end

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign imm_w_o = imm_r;


 endmodule // imm_gen
