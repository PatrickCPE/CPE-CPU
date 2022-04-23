//                              -*- Mode: Verilog -*-
// Filename        : alu.v
// Description     : alu unit for the RV32 ISA
// Author          : Patrick
// Created On      : Fri Apr 15 16:34:01 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 16:34:01 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!



//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module alu (/*AUTOARG*/
   // Outputs
   alu_res_w_o,
   // Inputs
   a_data_w_i, b_data_w_i, alu_control_w_i, addi_sub_flag_w_i,
   store_force_add_flag_w_i
   ) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input wire [31:0] a_data_w_i;
   input wire [31:0] b_data_w_i;
   input wire [3:0]  alu_control_w_i;
   input wire        addi_sub_flag_w_i;
   input wire        store_force_add_flag_w_i;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire [31:0] alu_res_w_o;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [31:0] alu_res_r;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------
   always @ (*) begin
      if (store_force_add_flag_w_i) begin
         alu_res_r = a_data_w_i + b_data_w_i; // Force Add for Store Byte ADD;
      end else begin
         case (alu_control_w_i)
            4'b0000: alu_res_r = a_data_w_i + b_data_w_i; // ADD;
            4'b0001: alu_res_r = a_data_w_i << b_data_w_i[4:0]; // SLL;
            4'b0010: alu_res_r = ($signed(a_data_w_i) < $signed(b_data_w_i)) ? 1 : 0; // SLT
            4'b0011: alu_res_r = (a_data_w_i < b_data_w_i) ? 1 : 0; // SLTU;
            4'b0100: alu_res_r = a_data_w_i ^ b_data_w_i; // XOR;
            4'b0101: alu_res_r = a_data_w_i >> b_data_w_i[4:0]; // SRL;
            4'b0110: alu_res_r = a_data_w_i | b_data_w_i; // OR;
            4'b0111: alu_res_r = a_data_w_i & b_data_w_i; // AND;
            4'b1000: begin
               if (addi_sub_flag_w_i) begin
                  alu_res_r = a_data_w_i - b_data_w_i; // SUB;
               end else begin
                  alu_res_r = a_data_w_i + b_data_w_i; // ADDI - Special Case;
               end
            end
            4'b1001: alu_res_r = a_data_w_i << b_data_w_i[4:0]; // SLL - IVERILOG NO ? Support;
            4'b1010: alu_res_r = ($signed(a_data_w_i) < $signed(b_data_w_i)) ? 1 : 0; // SLT - IVERILOG NO ? Support
            4'b1011: alu_res_r = (a_data_w_i < b_data_w_i) ? 1 : 0; // SLTU - IVERILOG NO ? Support
            4'b1101: alu_res_r = $signed(a_data_w_i) >>> b_data_w_i[4:0]; // SRA;
            4'b1111: alu_res_r = a_data_w_i & b_data_w_i; // AND - IVERILOG NO ? Support
            default: alu_res_r = 32'hXXXXXXXX; // Error if it enters
         endcase

      end
   end

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign alu_res_w_o = alu_res_r;

endmodule // alu

