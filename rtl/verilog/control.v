//                              -*- Mode: Verilog -*-
// Filename        : control.v
// Description     : contol signals for cpe cpu
// Author          : Patrick
// Created On      : Fri Apr 15 17:09:43 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:09:43 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!


//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module control (/*AUTOARG*/
   // Outputs
   reg_write_w_o_h, alu_src_a_w_o, alu_src_b_w_o, mem_wr_w_o_h, mem_rd_w_o_h,
   branch_w_o_h, mem_to_reg_w_o_h, jal_w_o_h, imm_to_reg_w_o_h, pc_to_reg_w_o,
   cmp_branch_w_o_h,
   // Inputs
   opcode_w_i
   ) ;


   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input wire [6:0] opcode_w_i;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire      reg_write_w_o_h;
   output wire      alu_src_a_w_o;
   output wire      alu_src_b_w_o;
   output wire      mem_wr_w_o_h;
   output wire      mem_rd_w_o_h;
   output wire      branch_w_o_h;
   output wire      mem_to_reg_w_o_h;
   output wire      jal_w_o_h;
   output wire      imm_to_reg_w_o_h;
   output wire      pc_to_reg_w_o;
   output wire      cmp_branch_w_o_h;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg reg_write_r_h;
   reg alu_src_a_r;
   reg alu_src_b_r;
   reg mem_wr_r_h;
   reg mem_rd_r_h;
   reg branch_r_h;
   reg mem_to_reg_r_h;
   reg jal_r_h;
   reg imm_to_reg_r_h;
   reg pc_to_reg_r;
   reg cmp_branch_r_h;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   // Order of instrs. for -> ordering seen on this doc (pg. 130)
   // https://riscv.org/wp-content/uploads/2019/12/riscv-spec-20191213.pdf

   always @ (*) begin
      case (opcode_w_i)
         7'b1101111: begin      // J Type - JAL;
            reg_write_r_h  = 1'b1;
            mem_wr_r_h     = 1'b0;
            mem_rd_r_h     = 1'b0;
            branch_r_h     = 1'b1;
            mem_to_reg_r_h = 1'b0;
            jal_r_h        = 1'b1;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b1;
            alu_src_b_r    = 1'b1;
            pc_to_reg_r    = 1'b1;
            cmp_branch_r_h = 1'b0;
         end
         7'b0110111: begin      // U Type - LUI;
            reg_write_r_h = 1'b1;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b0;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b1;
            alu_src_a_r    = 1'b0;
            alu_src_b_r    = 1'b0;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b0;
         end
         7'b0010111: begin      // U Type - AUIPC;
            reg_write_r_h = 1'b1;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b0;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b1;
            alu_src_b_r    = 1'b1;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b0;
         end
         7'b1100011: begin      // B Type - BEQ -> BGEU;
            reg_write_r_h = 1'b0;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b1;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b1;
            alu_src_b_r    = 1'b1;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b1;
         end
         7'b0100011: begin      // S Type - SB -> SW;
            reg_write_r_h = 1'b0;
            mem_wr_r_h = 1'b1;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b0;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b0;
            alu_src_b_r    = 1'b0;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b0;
         end
         7'b1100111: begin      // I Type - JALR;
            reg_write_r_h = 1'b1;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b1;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b1;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b1;
            alu_src_b_r    = 1'b1;
            pc_to_reg_r    = 1'b1;
            cmp_branch_r_h = 1'b0;
         end
         7'b0000011: begin      // I Type - LB -> LHU;
            reg_write_r_h = 1'b1;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b1;
            branch_r_h = 1'b0;
            mem_to_reg_r_h = 1'b1;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b0;
            alu_src_b_r    = 1'b1;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b0;
         end
         7'b0010011: begin      // I Type - ADDI -> SRAI;
            reg_write_r_h = 1'b1;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b0;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b0;
            alu_src_b_r    = 1'b1;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b0;
         end
         7'b0110011: begin      // R Type - ADD -> AND
            reg_write_r_h = 1'b1;
            mem_wr_r_h = 1'b0;
            mem_rd_r_h = 1'b0;
            branch_r_h = 1'b0;
            mem_to_reg_r_h = 1'b0;
            jal_r_h = 1'b0;
            imm_to_reg_r_h = 1'b0;
            alu_src_a_r    = 1'b0;
            alu_src_b_r    = 1'b0;
            pc_to_reg_r    = 1'b0;
            cmp_branch_r_h = 1'b0;
         end
         default: begin
            reg_write_r_h = 1'bx;
            mem_wr_r_h = 1'bx;
            mem_rd_r_h = 1'bx;
            branch_r_h = 1'bx;
            mem_to_reg_r_h = 1'bx;
            jal_r_h = 1'bx;
            imm_to_reg_r_h = 1'bx;
            alu_src_a_r    = 1'bx;
            alu_src_b_r    = 1'bx;
            pc_to_reg_r    = 1'bx;
            cmp_branch_r_h = 1'bx;
         end
      endcase // case (opcode_w_i)
   end


   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign reg_write_w_o_h = reg_write_r_h;
   assign mem_wr_w_o_h = mem_wr_r_h;
   assign mem_rd_w_o_h = mem_rd_r_h;
   assign branch_w_o_h = branch_r_h;
   assign mem_to_reg_w_o_h = mem_to_reg_r_h;
   assign jal_w_o_h = jal_r_h;
   assign imm_to_reg_w_o_h = imm_to_reg_r_h;
   assign alu_src_a_w_o = alu_src_a_r;
   assign alu_src_b_w_o = alu_src_b_r;
   assign pc_to_reg_w_o = pc_to_reg_r;
   assign cmp_branch_w_o_h = cmp_branch_r_h;

endmodule // control

