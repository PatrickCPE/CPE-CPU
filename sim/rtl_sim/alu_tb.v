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
module alu_tb (/*AUTOARG*/) ;

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
   reg [31:0]         a_data_tb_i;
   reg [31:0]         b_data_tb_i;
   reg [3:0]          alu_control_tb_i;

   wire [31:0]        a_data_w_i;
   wire [31:0]        b_data_w_i;
   wire [3:0]         alu_control_w_i;


   wire [31:0]        alu_res_w_o;
   wire               zero_w_o_h;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   alu duv(/*AUTOINST*/
           // Outputs
           .alu_res_w_o                 (alu_res_w_o),
           .zero_w_o_h                  (zero_w_o_h),
           // Inputs
           .a_data_w_i                  (a_data_w_i),
           .b_data_w_i                  (b_data_w_i),
           .alu_control_w_i             (alu_control_w_i));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign a_data_w_i = a_data_tb_i;
   assign b_data_w_i = b_data_tb_i;
   assign alu_control_w_i = alu_control_tb_i;

   //-----------------------------------------------------------------------------
   // Tasks
   //-----------------------------------------------------------------------------
   task run_instr(input [3:0] instr, input [31:0] a_val, input [31:0] b_val);
      begin
         a_data_tb_i      = a_val;
         b_data_tb_i      = b_val;
         alu_control_tb_i = instr;
         #DELAY;

         case (instr)
            4'b0000: begin      // Add
               expected_val = a_val + b_val;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A + B;\nExpected:%h\nReceived:%h\n", $time, expected_val, alu_res_w_o);
               end
            end
            4'b0001: begin      // SLL
               expected_val = a_val << b_val[4:0];
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A << B[4:0];\nExpected:%h\nReceived:h\n", $time, expected_val,
                           alu_res_w_o);
               end
            end
            4'b0010: begin      // SLT
               expected_val = ($signed(a_val) < $signed(b_val)) ? 1 : 0;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A < B ? 1 : 0;\nExpected:%h\nReceived:h\n", $time,
                           expected_val, alu_res_w_o);
               end
            end
            4'b0011: begin      // SLTU
               expected_val = (a_val < b_val) ? 1 : 0;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  $display("%d ns: Error A < B UNSIGNED;\nExpected:%h\nReceived:h\n", $time,
                           expected_val, alu_res_w_o);
               end
            end
            4'b0100: begin      // XOR
               expected_val = a_val ^ b_val;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  $display("%d ns: Error A ^ B;\nExpected:%h\nReceived:h\n", $time, expected_val, alu_res_w_o);
               end
            end
            4'b0101: begin      // SRL
               expected_val = a_val >> b_val[4:0];
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A >> B[4:0];\nExpected:%h\nReceived:h\n", $time, expected_val, alu_res_w_o);
               end
            end
            4'b0110: begin      // OR
               expected_val = a_val | b_val;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A | B;\nExpected:%h\nReceived:h\n", $time, expected_val, alu_res_w_o);
               end
            end
            4'b0111: begin      // AND
               expected_val = a_val & b_val;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  errors = errors + 1;
                  $display("%d ns: Error A & B;\nExpected:%h\nReceived:h\n", $time, expected_val, alu_res_w_o);
               end
            end
            4'b1000: begin      // SUB
               expected_val = a_val - b_val;
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A - B;\nExpected:%h\nReceived:h\n", $time, expected_val, alu_res_w_o);
               end
            end
            4'b1101: begin      // SRA
               expected_val = a_val >>> b_val[4:0];
               #DELAY;
               if (alu_res_w_o !== expected_val) begin
                  errors = errors + 1;
                  $display("%d ns: Error A >>> B;\nExpected:%h\nReceived:h\n", $time, expected_val, alu_res_w_o);
               end
            end
            default: begin
               errors = errors + 1;
               $display("%d ns: FATAL INVALID ALU INSTR:%b\n", $time, instr);
            end
         endcase // case (instr)
         #DELAY
         if ((alu_res_w_o == 0) && (zero_w_o_h != 1)) begin
            errors = errors + 1;
            $display("%d ns: Error Zero Flag Failure Instr:%b Res:%h Flag:%b\n", $time, instr,
                     alu_res_w_o, zero_w_o_h);
         end
      end
   endtask

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   if (TRACE == 1) initial begin
      $dumpfile("alu.vcd");
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
         a_value = $random;
         b_value = $random;
         #DELAY;

         // Add
         run_instr(4'b0000, a_value, b_value);

         // SLL
         run_instr(4'b0001, a_value, b_value);

         // SLT
         run_instr(4'b0010, a_value, b_value);

         // SLTU
         run_instr(4'b0011, a_value, b_value);

         // XOR
         run_instr(4'b0100, a_value, b_value);

         // SRL
         run_instr(4'b0101, a_value, b_value);

         // OR
         run_instr(4'b0110, a_value, b_value);

         // AND
         run_instr(4'b0111, a_value, b_value);

         // SUB
         run_instr(4'b1000, a_value, b_value);

         // SRA
         run_instr(4'b1101, a_value, b_value);
      end
      $display("%d ns: finished with %d errors over %d trials\n", $time, errors, NUM_TRIALS);
   end

endmodule // alu_tb

