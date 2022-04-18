//                              -*- Mode: Verilog -*-
// Filename        : imm_gen_tb.v
// Description     : imm gen tb
// Author          : Patrick
// Created On      : Fri Apr 15 17:22:08 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:22:08 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ps

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module imm_gen_tb (/*AUTOARG*/) ;


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
   parameter NUM_TRIALS = 10_000;
   parameter DELAY = 1;         // TODO DETERMINE PROPER DELAY FOR SPEED GRADE
   parameter J = 1,
      U = 2,
      S = 3,
      B = 4,
      I = 5;

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg [31:0] instr_tb_i;

   wire [31:0] imm_w_o;
   wire [31:0] instr_w_i;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   imm_gen duv(/*AUTOINST*/
               // Outputs
               .imm_w_o                 (imm_w_o),
               // Inputs
               .instr_w_i               (instr_w_i));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign instr_w_i = instr_tb_i;

   //-----------------------------------------------------------------------------
   // Tasks
   //-----------------------------------------------------------------------------
   task gen_i_expected(input [6:0] instr, input [2:0] instr_type);
      begin
         rand_val     = $random;
         test_instr   = {rand_val[11:0], {13{1'b0}}, instr};
         instr_tb_i   = test_instr;
         expected_val = {{20{rand_val[11]}}, rand_val[11:0]};
      end
   endtask

   task test_instruction(input [6:0] instr, input [2:0] instr_type);
      begin
         #DELAY;
         for (i = 0; i < NUM_TRIALS; i = i + 1) begin
            #DELAY;
            case (instr_type)
               J: begin
               end
               U: begin
               end
               S: begin
               end
               B: begin
               end
               I: begin
                  gen_i_expected(instr, instr_type);
               end
               default: begin
                  $display("%d ns: ERROR INVALID INSTRUCTION TYPE");
               end
            endcase // case (instr_type)

            #DELAY;
            if (imm_w_o !== expected_val) begin
               $display("%d ns: I Type Fail Expected:%b Received:%b\n", $time, expected_val, imm_w_o);
               errors = errors + 1;
            end
         end // for (i = 0; i < NUM_TRIALS; i = i + 1)
      end
   endtask // test_instruction

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------

   if (TRACE == 1) initial begin
      $dumpfile("imm_gen.vcd");
      $dumpvars;
   end


   integer i, rand_val, test_instr, errors;
   reg [31:0] expected_val;
   //    // Method is to test 1 instruction with for each opcode pattern with a randomly
   // generated immediate value. One of each opcode for each instr type is tested.
   initial begin
      #DELAY;
      errors = 0;
      // I type instructions
      test_instruction(7'b1100111, I); // JALR
      test_instruction(7'b0000011, I); // LB
      test_instruction(7'b0010011, I); // ADDI
      $display("%d ns: finished with %d errors over %d trials\n", $time, errors, NUM_TRIALS);
   end

endmodule // imm_gen_tb

