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
module cmp_gen (/*AUTOARG*/
   // Outputs
   eq_w_o_h, gteu_w_o_h, ltu_w_o_h, gtes_w_o_h, lts_w_o_h,
   // Inputs
   rd_data_1_w_i, rd_data_2_w_i
   ) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input wire [31:0] rd_data_1_w_i;
   input wire [31:0] rd_data_2_w_i;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire        eq_w_o_h;
   output wire        gteu_w_o_h;
   output wire        ltu_w_o_h;
   output wire        gtes_w_o_h;
   output wire        lts_w_o_h;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign eq_w_o_h = (rd_data_1_w_i == rd_data_2_w_i);
   assign gteu_w_o_h = ((rd_data_1_w_i >= rd_data_2_w_i) ? 1 : 0);
   assign ltu_w_o_h = ((rd_data_1_w_i < rd_data_2_w_i) ? 1 : 0);
   assign gtes_w_o_h = (($signed(rd_data_1_w_i) >= $signed(rd_data_2_w_i)) ? 1 : 0);
   assign lts_w_o_h = (($signed(rd_data_1_w_i) < $signed(rd_data_2_w_i)) ? 1 : 0);

endmodule // alu
