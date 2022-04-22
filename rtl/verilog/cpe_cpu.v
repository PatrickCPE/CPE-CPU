//                              -*- Mode: Verilog -*-
// Filename        : cpe_cpu.v
// Description     : risk-v softcore processor implementing the RV32I spec
// Author          : Patrick
// Created On      : Fri Apr 15 15:18:58 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 15:18:58 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!


//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module cpe_cpu (/*AUTOARG*/
   // Outputs
   mem_data_in_w_o, instr_w_o, mem_wr_w_o_h, mem_rd_w_o_h, mem_wr_byte_sel_w_o,
   mem_rd_byte_sel_w_o,
   // Inputs
   clk_w_i, res_w_i_h, instr_w_i, mem_data_w_o
   ) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input wire clk_w_i;
   input wire res_w_i_h;
   input wire [31:0] instr_w_i;
   input wire [31:0] mem_data_w_o;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire [31:0] mem_data_in_w_o;
   output wire [31:0] instr_w_o;
   output wire                             mem_wr_w_o_h;
   output wire                             mem_rd_w_o_h;
   output wire [1:0]                       mem_wr_byte_sel_w_o;
   output wire [1:0]                       mem_rd_byte_sel_w_o;

   //-----------------------------------------------------------------------------
   // Parameters
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   // PC
   wire [31:0]                             pc_w_i;

   // REGISTERS
   wire [4:0]                              rd_reg_1_w_i;
   wire [4:0]                              rd_reg_2_w_i;
   wire [4:0]                              wr_reg_w_i; // TODO FIX
   wire [31:0]                             wr_data_w_i;
   wire [31:0]                             rd_data_1_w_o;
   wire [31:0]                             rd_data_2_w_o;


   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

/* -----\/----- EXCLUDED -----\/-----
   alu alu_0(/-*AUTOINST*-/
             // Outputs
             .alu_res_w_o               (alu_res_w_o[31:0]),
             .eq_w_o_h                  (eq_w_o_h),
             .gteu_w_o_h                (gteu_w_o_h),
             .ltu_w_o_h                 (ltu_w_o_h),
             .gtes_w_o_h                (gtes_w_o_h),
             .lts_w_o_h                 (lts_w_o_h),
             // Inputs
             .a_data_w_i                (a_data_w_i[31:0]),
             .b_data_w_i                (b_data_w_i[31:0]),
             .alu_control_w_i           (alu_control_w_i[3:0]));

   cond_branch_control cbc_0(/-*AUTOINST*-/
                             // Outputs
                             .cond_branch_w_o_h (cond_branch_w_o_h),
                             // Inputs
                             .funct_3_w_i       (funct_3_w_i[2:0]),
                             .eq_w_i_h          (eq_w_i_h),
                             .gteu_w_i_h        (gteu_w_i_h),
                             .gtes_w_i_h        (gtes_w_i_h),
                             .ltu_w_i_h         (ltu_w_i_h),
                             .lts_w_i_h         (lts_w_i_h),
                             .cmp_branch_w_i_h  (cmp_branch_w_i_h));

   imm_gen imm_gen_0(/-*AUTOINST*-/
                     // Outputs
                     .imm_w_o           (imm_w_o[31:0]),
                     // Inputs
                     .instr_w_i         (instr_w_i));

 -----/\----- EXCLUDED -----/\----- */


   pc pc_0(/*AUTOINST*/
           // Outputs
           .instr_w_o                   (instr_w_o),
           // Inputs
           .pc_w_i                      (pc_w_i),
           .clk_w_i                     (clk_w_i),
           .res_w_i_h                   (res_w_i_h));

   registers registers_0(/*AUTOINST*/
                         // Outputs
                         .rd_data_1_w_o         (rd_data_1_w_o),
                         .rd_data_2_w_o         (rd_data_2_w_o),
                         // Inputs
                         .clk_w_i               (clk_w_i),
                         .res_w_i_h             (res_w_i_h),
                         .rd_reg_1_w_i          (rd_reg_1_w_i),
                         .rd_reg_2_w_i          (rd_reg_2_w_i),
                         .wr_reg_w_i            (wr_reg_w_i[4:0]),
                         .wr_data_w_i           (wr_data_w_i),
                         .reg_wr_flag_w_i       (reg_wr_flag_w_i));


   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   // PC
   assign pc_w_i = 0;           // TODO REALT

   // REGISTERS
   assign rd_reg_1_w_i = instr_w_i[19:15];
   assign rd_reg_2_w_i = instr_w_i[24:20];
   assign wr_reg_w_i = instr_w_i[11:7];

endmodule // cpe_cpu

