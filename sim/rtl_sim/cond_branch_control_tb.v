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
module cond_branch_control_tb (/*AUTOARG*/) ;

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

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [2:0] funct_3_tb_i;
   reg       eq_tb_i_h;
   reg       gteu_tb_i_h;
   reg       gtes_tb_i_h;
   reg       ltu_tb_i_h;
   reg       lts_tb_i_h;
   reg       cmp_branch_tb_i_h;


   wire [2:0] funct_3_w_i;
   wire       eq_w_i_h;
   wire       gteu_w_i_h;
   wire       gtes_w_i_h;
   wire       ltu_w_i_h;
   wire       lts_w_i_h;
   wire       cmp_branch_w_i_h;

   wire       cond_branch_w_o_h;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   cond_branch_control duv(/*AUTOINST*/
                           // Outputs
                           .cond_branch_w_o_h   (cond_branch_w_o_h),
                           // Inputs
                           .funct_3_w_i         (funct_3_w_i),
                           .eq_w_i_h            (eq_w_i_h),
                           .gteu_w_i_h          (gteu_w_i_h),
                           .gtes_w_i_h          (gtes_w_i_h),
                           .ltu_w_i_h           (ltu_w_i_h),
                           .lts_w_i_h           (lts_w_i_h),
                           .cmp_branch_w_i_h    (cmp_branch_w_i_h));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign funct_3_w_i = funct_3_tb_i;
   assign eq_w_i_h = eq_tb_i_h;
   assign gteu_w_i_h = gteu_tb_i_h;
   assign gtes_w_i_h = gtes_tb_i_h;
   assign ltu_w_i_h = ltu_tb_i_h;
   assign lts_w_i_h = lts_tb_i_h;
   assign cmp_branch_w_i_h = cmp_branch_tb_i_h;


   //-----------------------------------------------------------------------------
   // Tasks
   //-----------------------------------------------------------------------------
   task run_test;
      begin
         #DELAY;
         if (cond_branch_w_o_h !== expected) begin
            $display("%d ns: ERROR %s\n", $time, task_name);
            $display("Expected:%b Received:%b\n", expected, cond_branch_w_o_h);
            errors = errors + 1;
         end
      end
   endtask // run_test

   task reset;
      begin
         funct_3_tb_i      = 3'b000;
         eq_tb_i_h         = 0;
         gteu_tb_i_h       = 0;
         gtes_tb_i_h       = 0;
         ltu_tb_i_h        = 0;
         lts_tb_i_h        = 0;
         cmp_branch_tb_i_h = 0;
         expected          = 0;
         #DELAY;
      end
   endtask // reset

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   if (TRACE == 1) initial begin
      $dumpfile("cond_branch_control.vcd");
      $dumpvars;
   end

   integer errors;
   reg     expected;
   reg [31:0] task_name;
   initial begin
      #DELAY;
      errors = 0;
      #DELAY;

      // DESERT BOTH
      // ASSERT CNDT LINE, DESSERT CMP BRANCH
      // DESSERT CNDT LINE, ASSERT CMP BRANCH
      // ASSERT BOTH

      // BEQ
      reset();
      task_name         = "BEQ";
      funct_3_tb_i      = 3'b000;
      expected          = 0;
      eq_tb_i_h         = 0;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      eq_tb_i_h = 1;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      eq_tb_i_h = 0;
      cmp_branch_tb_i_h = 1;
      run_test();
      expected          = 1;
      eq_tb_i_h = 1;
      cmp_branch_tb_i_h = 1;
      run_test();

      // BNE
      reset();
      task_name         = "BEQ";
      funct_3_tb_i      = 3'b001;
      expected          = 0;
      eq_tb_i_h         = 1;    // Inverted Logic
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      eq_tb_i_h         = 0;    // Inverted Logic
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      eq_tb_i_h         = 1;    // Inverted Logic
      cmp_branch_tb_i_h = 1;
      run_test();
      expected          = 1;
      eq_tb_i_h         = 0;    // Inverted Logic
      cmp_branch_tb_i_h = 1;
      run_test();

      // LTS
      reset();
      task_name    = "LTS";
      funct_3_tb_i = 3'b100;
      expected          = 0;
      lts_tb_i_h = 0;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      lts_tb_i_h = 1;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      lts_tb_i_h = 0;
      cmp_branch_tb_i_h = 1;
      run_test();
      expected          = 1;
      lts_tb_i_h = 1;
      cmp_branch_tb_i_h = 1;
      run_test();

      // GTES
      reset();
      task_name    = "GTES";
      funct_3_tb_i = 3'b101;
      expected          = 0;
      gtes_tb_i_h = 0;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      gtes_tb_i_h = 1;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      gtes_tb_i_h = 0;
      cmp_branch_tb_i_h = 1;
      run_test();
      expected          = 1;
      gtes_tb_i_h = 1;
      cmp_branch_tb_i_h = 1;
      run_test();

      // LTU
      reset();
      task_name    = "LTU";
      funct_3_tb_i = 3'b110;
      expected          = 0;
      ltu_tb_i_h = 0;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      ltu_tb_i_h = 1;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      ltu_tb_i_h = 0;
      cmp_branch_tb_i_h = 1;
      run_test();
      expected          = 1;
      ltu_tb_i_h = 1;
      cmp_branch_tb_i_h = 1;
      run_test();

      // GTEU
      reset();
      task_name         = "GTEU";
      funct_3_tb_i      = 3'b111;
      expected          = 0;
      gteu_tb_i_h = 0;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      gteu_tb_i_h = 1;
      cmp_branch_tb_i_h = 0;
      run_test();
      expected          = 0;
      gteu_tb_i_h = 0;
      cmp_branch_tb_i_h = 1;
      run_test();
      expected          = 1;
      gteu_tb_i_h = 1;
      cmp_branch_tb_i_h = 1;
      run_test();


      $display("%d ns: finished with %d errors\n", $time, errors);
   end

endmodule // cond_branch_control_tb

