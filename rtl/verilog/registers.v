//                              -*- Mode: Verilog -*-
// Filename        : registers.v
// Description     : register file for cpe cpu
// Author          : Patrick
// Created On      : Fri Apr 15 17:25:46 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:25:46 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module registers (/*AUTOARG*/
   // Outputs
   rd_data_1_w_o, rd_data_2_w_o,
   // Inputs
   clk_w_i, res_w_i_h, rd_reg_1_w_i, rd_reg_2_w_i, wr_reg_w_i, wr_data_w_i,
   reg_wr_flag_w_i
   ) ;


   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input wire clk_w_i;
   input wire res_w_i_h;

   input wire [4:0] rd_reg_1_w_i;
   input wire [4:0] rd_reg_2_w_i;
   input wire [4:0] wr_reg_w_i;
   input wire [31:0] wr_data_w_i;

   input wire        reg_wr_flag_w_i;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire [31:0] rd_data_1_w_o;
   output wire [31:0] rd_data_2_w_o;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [31:0]         register [31:0];

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------
   integer            i;
   always @ (posedge clk_w_i or posedge res_w_i_h) begin
      if (res_w_i_h) begin
         for (i = 0; i < 32; i = i + 1) begin
            register[i] <= 0;
         end
      end else begin
         if (reg_wr_flag_w_i) begin
            register[wr_reg_w_i] <= wr_data_w_i;
         end
      end
   end

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign rd_data_1_w_o = register[rd_reg_1_w_i];
   assign rd_data_2_w_o = register[rd_reg_2_w_i];

endmodule // registers

