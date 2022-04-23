//                              -*- Mode: Verilog -*-
// Filename        : control_tb.v
// Description     : control generator testbench
// Author          : Patrick
// Created On      : Fri Apr 15 17:10:26 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:10:26 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ps

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module control_tb (/*AUTOARG*/) ;


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
   parameter DELAY = 1;

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [6:0] opcode_tb_i;

   wire [6:0] opcode_w_i;

   wire [10:0] output_bus;

   wire       reg_write_w_o_h;
   wire       mem_wr_w_o_h;
   wire       mem_rd_w_o_h;
   wire       branch_w_o_h;
   wire       mem_to_reg_w_o_h;
   wire       jal_w_o_h;
   wire       imm_to_reg_w_o_h;
   wire       alu_src_a_w_o;
   wire       alu_src_b_w_o;
   wire       pc_to_reg_w_o;
   wire       cmp_branch_w_o_h;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   control duv(/*AUTOINST*/
               // Outputs
               .reg_write_w_o_h         (reg_write_w_o_h),
               .alu_src_a_w_o           (alu_src_a_w_o),
               .alu_src_b_w_o           (alu_src_b_w_o),
               .mem_wr_w_o_h            (mem_wr_w_o_h),
               .mem_rd_w_o_h            (mem_rd_w_o_h),
               .branch_w_o_h            (branch_w_o_h),
               .mem_to_reg_w_o_h        (mem_to_reg_w_o_h),
               .jal_w_o_h               (jal_w_o_h),
               .imm_to_reg_w_o_h        (imm_to_reg_w_o_h),
               .pc_to_reg_w_o           (pc_to_reg_w_o),
               .cmp_branch_w_o_h        (cmp_branch_w_o_h),
               // Inputs
               .opcode_w_i              (opcode_w_i));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign opcode_w_i = opcode_tb_i;

   // Makes it easier to compare against my spreadsheet
   assign output_bus = {reg_write_w_o_h, mem_wr_w_o_h, mem_rd_w_o_h, branch_w_o_h,
                        mem_to_reg_w_o_h, jal_w_o_h, imm_to_reg_w_o_h,
                        alu_src_a_w_o, alu_src_b_w_o, pc_to_reg_w_o,
                        cmp_branch_w_o_h};


   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   if (TRACE == 1) initial begin
      $dumpfile("control.vcd");
      $dumpvars;
   end

   integer errors;
   reg [10:0] expected;
   initial begin
      errors = 0;
      #DELAY;

      opcode_tb_i = 7'b0000000;
      expected = 11'bxxx_xxxx_xxxx;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error couldn't handle invalid instruction\n", $time);
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b110_1111;
      expected = 11'b100_1010_1110;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error j type - jal;\n", $time);
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b011_0111;
      expected = 11'b100_0001_0000;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error u type - lui\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b001_0111;
      expected = 11'b100_0000_1100;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error u type - auipc\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b110_0011;
      expected = 11'b000_1000_1101;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error b type beq -> bgeu\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b010_0011;
      expected = 11'b010_0000_0100;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error s type sb -> sw\n");
         $display("expected:%h received %h\n", $time, expected, output_bus);
      end

      opcode_tb_i = 7'b110_0111;
      expected = 11'b100_1010_1110;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error i type jalr\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b000_0011;
      expected = 11'b101_0100_0100;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error i type lb -> lhw\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b001_0011;
      expected = 11'b100_0000_0100;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error i type addi -> srai\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      opcode_tb_i = 7'b011_0011;
      expected = 11'b100_0000_0000;
      #DELAY;
      if (output_bus !== expected) begin
         errors = errors + 1;
         $display("%d ns: error r type add -> and\n");
         $display("expected:%h received %h\n", expected, output_bus);
      end

      $display("%d ns: finished with %d errors\n", $time, errors);
   end

endmodule // control_tb

