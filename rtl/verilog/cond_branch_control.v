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
module cond_branch_control (/*AUTOARG*/
   // Outputs
   cond_branch_w_o_h,
   // Inputs
   funct_3_w_i, eq_w_i_h, gteu_w_i_h, gtes_w_i_h, ltu_w_i_h, lts_w_i_h,
   cmp_branch_w_i_h
   ) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------

   // Instruction Field
   input wire [2:0] funct_3_w_i;

   // ALU output flags
   input wire        eq_w_i_h;
   input wire        gteu_w_i_h;
   input wire        gtes_w_i_h;
   input wire        ltu_w_i_h;
   input wire        lts_w_i_h;

   // Control line
   input wire        cmp_branch_w_i_h;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire       cond_branch_w_o_h;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   wire [5:0]        internal_value;
   wire              inter_res;
   reg [5:0]        compare_mask;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------
   always @ (*) begin
      case (funct_3_w_i)
         3'b000: begin          // BEQ
            compare_mask = 6'b10_0000;
         end
         3'b001: begin          // BNE
            compare_mask = 6'b01_0000;
         end
         3'b100: begin          // BLT
            compare_mask = 6'b00_1000;
         end
         3'b101: begin          // BGE
            compare_mask = 6'b00_0100;
         end
         3'b110: begin          // BLTU
            compare_mask = 6'b00_0010;
         end
         3'b111: begin          // BGEU
            compare_mask = 6'b00_0001;
         end
         default: begin
            compare_mask = 6'b00_0000;
         end
      endcase // case (funct_3_w_i)
   end

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign internal_value[5] = (compare_mask[5] & eq_w_i_h);
   assign internal_value[4] = (compare_mask[4] & (~eq_w_i_h));
   assign internal_value[3] = (compare_mask[3] & lts_w_i_h);
   assign internal_value[2] = (compare_mask[2] & gtes_w_i_h);
   assign internal_value[1] = (compare_mask[1] & ltu_w_i_h);
   assign internal_value[0] = (compare_mask[0] & gteu_w_i_h);

   assign inter_res = |internal_value;

   assign cond_branch_w_o_h = inter_res & cmp_branch_w_i_h;

endmodule // cond_branch_control

