//                              -*- Mode: Verilog -*-
// Filename        : alu_tb.v
// Description     : test bench for the ALU module
// Author          : Patrick
// Created On      : Wed Apr 20 23:04:32 2022
// Last Modified By: Patrick
// Last Modified On: Wed Apr 20 23:04:32 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ps

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module cmp_gen_tb (/*AUTOARG*/) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------
   parameter TRACE = 1;
   parameter DELAY = 1;         // TODO SET PROPER
   parameter NUM_TRIALS = 10_000;

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [31:0]         rd_data_1_tb_i;
   reg [31:0]         rd_data_2_tb_i;

   wire [31:0]        rd_data_1_w_i;
   wire [31:0]        rd_data_2_w_i;

   wire               eq_w_o_h;
   wire               gtes_w_o_h;
   wire               lts_w_o_h;
   wire               gteu_w_o_h;
   wire               ltu_w_o_h;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   cmp_gen duv(/*AUTOINST*/
               // Outputs
               .eq_w_o_h                (eq_w_o_h),
               .gteu_w_o_h              (gteu_w_o_h),
               .ltu_w_o_h               (ltu_w_o_h),
               .gtes_w_o_h              (gtes_w_o_h),
               .lts_w_o_h               (lts_w_o_h),
               // Inputs
               .rd_data_1_w_i           (rd_data_1_w_i),
               .rd_data_2_w_i           (rd_data_2_w_i));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign rd_data_1_w_i = rd_data_1_tb_i;
   assign rd_data_2_w_i = rd_data_2_tb_i;

   //-----------------------------------------------------------------------------
   // Tasks
   //-----------------------------------------------------------------------------
   task run_instr(input [31:0] a_val, input [31:0] b_val);
      begin
         rd_data_1_tb_i = a_val;
         rd_data_2_tb_i = b_val;
         #DELAY;

         // Comparison Flags
         if ((rd_data_1_tb_i == rd_data_2_tb_i) & (!eq_w_o_h)) begin
            errors = errors + 1;
            $display("%d ns: Error Zero Flag Failure Flag:%b\n", $time, eq_w_o_h);
         end

         if ((rd_data_1_tb_i < rd_data_2_tb_i) & (!ltu_w_o_h)) begin
            errors = errors + 1;
            $display("%d ns: Error Less Than Unsigned Flag Failure Flag:%b\n", $time, ltu_w_o_h);
         end

         if (($signed(rd_data_1_tb_i) < $signed(rd_data_2_tb_i)) & (!lts_w_o_h)) begin
            errors = errors + 1;
            $display("%d ns: Error Less Than signed Flag Failure Flag:%b\n", $time, lts_w_o_h);
         end

         if ((rd_data_1_tb_i >= rd_data_2_tb_i) & (!gteu_w_o_h)) begin
            errors = errors + 1;
            $display("%d ns: Error Greater Than Equal signed Flag Failure Flag:%b\n", $time, gtes_w_o_h);
         end

         if (($signed(rd_data_1_tb_i) >= $signed(rd_data_2_tb_i)) & (!gtes_w_o_h)) begin
            errors = errors + 1;
            $display("%d ns: Error Greater Than Equal signed Flag Failure Flag:%b\n", $time, gtes_w_o_h);
         end
      end
   endtask

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   if (TRACE == 1) initial begin
      $dumpfile("cmp_gen.vcd");
      $dumpvars;
   end

   integer i, a_value, b_value, errors;
   reg [31:0] expected_val;

   initial begin
      #DELAY;
      errors = 0;
      #DELAY;

      for (i = 0; i < NUM_TRIALS; i = i + 1) begin

         // Generate Test Values
         #DELAY;
         a_value = $random;
         b_value = $random;
         #DELAY;

         run_instr(a_value, b_value);

         #DELAY;
         a_value = $random;
         b_value = a_value;
         #DELAY
         run_instr(a_value, b_value);
      end
      $display("%d ns: finished with %d errors over %d trials\n", $time, errors, NUM_TRIALS);
   end

endmodule // alu_tb

