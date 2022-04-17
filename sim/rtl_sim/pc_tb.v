//                              -*- Mode: Verilog -*-
// Filename        : pc_tb.v
// Description     : pc tb
// Author          : Patrick
// Created On      : Fri Apr 15 17:23:38 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:23:38 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ps

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module pc_tb (/*AUTOARG*/) ;


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

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [31:0] pc_tb_i;
   reg        clk_tb_i;
   reg        res_tb_i_h;

   wire [31:0] instr_w_o;
   wire [31:0] pc_w_i;
   wire clk_w_i;
   wire res_w_i_h;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   pc duv(/*AUTOINST*/
          // Outputs
          .instr_w_o                    (instr_w_o),
          // Inputs
          .pc_w_i                       (pc_w_i),
          .clk_w_i                      (clk_w_i),
          .res_w_i_h                    (res_w_i_h));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign pc_w_i = pc_tb_i;
   assign clk_w_i = clk_tb_i;
   assign res_w_i_h = res_tb_i_h;

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   always begin
      //TODO ACTUAL CLOCK FREQ
      #1 clk_tb_i = ~clk_tb_i;
   end

   if (TRACE == 1) initial begin
      $dumpfile("pc.vcd");
      $dumpvars;
   end

   integer i, errors, num_trials, res_done;
   reg [31:0] prev_count;
   initial begin
      clk_tb_i       = 0;
      errors         = 0;
      num_trials     = 10_000;
      res_done       = 0;

      // Asert Reset
      #10 res_tb_i_h = 0;
      #10 res_tb_i_h = 1;
      #10 res_tb_i_h = 0;
      for (i = 0; i < num_trials; i = i + 1) begin
         pc_tb_i = $urandom;
         @ (posedge clk_w_i) begin
            if ((instr_w_o !== prev_count) & (res_done)) begin
               if (instr_w_o !== pc_w_i) begin
                  $display("%d ns: expected:%h received:%h prev_count:%h\n", $time, instr_w_o, pc_w_i, prev_count);
                  errors <= errors + 1;
               end
            end
            prev_count <= instr_w_o;
            res_done <= 1;
         end
      end // for (i = 0; i < num_trials; i = i + 1)
      $display("%d ns: finished with %d errors over %d trials\n", $time, errors, num_trials);
      $finish;
   end
endmodule // pc_tb

