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
   mem_data_in_w_o, mem_addr_in_w_o, instr_w_o, mem_wr_w_o_h, mem_rd_w_o_h,
   mem_wr_byte_sel_w_o, mem_rd_byte_sel_w_o,
   // Inputs
   clk_w_i, res_w_i_h, instr_w_i, mem_data_w_i
   ) ;

   //-----------------------------------------------------------------------------
   // Inputs
   //-----------------------------------------------------------------------------
   input wire clk_w_i;
   input wire res_w_i_h;
   input wire [31:0] instr_w_i;
   input wire [31:0] mem_data_w_i;

   //-----------------------------------------------------------------------------
   // Outputs
   //-----------------------------------------------------------------------------
   output wire [31:0] mem_data_in_w_o;
   output wire [31:0] mem_addr_in_w_o;
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
   // Input
   wire [31:0]                             pc_w_i;

   // REGISTERS
   // Input
   wire [4:0]                              rd_reg_1_w_i;
   wire [4:0]                              rd_reg_2_w_i;
   wire [4:0]                              wr_reg_w_i;
   wire [31:0]                             wr_data_w_i;
   // Output
   wire [31:0]                             rd_data_1_w_o;
   wire [31:0]                             rd_data_2_w_o;

   // IMM GEN
   // Output
   wire [31:0]                             imm_w_o;

   // CONTROL - TOP LEVEL
   // Input
   wire [6:0]                              opcode_w_i;
   // Output
   wire                                    reg_write_o_h;
   wire                                    alu_src_a_w_o;
   wire                                    alu_src_b_w_o;
   wire                                    branch_w_o_h;
   wire                                    mem_to_reg_w_o_h;
   wire                                    jal_w_o_h;
   wire                                    imm_to_reg_w_o_h;
   wire                                    pc_to_reg_w_o;
   wire                                    cmp_branch_w_o_h;

   // ALU
   // Input
   wire [31:0]                             a_data_w_i;
   wire [31:0]                             b_data_w_i;
   wire [3:0]                              alu_control_w_i;
   wire                                    addi_sub_flag;
   wire                                    store_force_add_flag_w_i;
   // Output
   wire [31:0]                             alu_res_w_o;
   wire                                    eq_w_o_h;
   wire                                    gteu_w_o_h;
   wire                                    ltu_w_o_h;
   wire                                    gtes_w_o_h;
   wire                                    lts_w_o_h;

   // CONTROL - CONDITIONAL BRANCH
   // Input
   wire [2:0]                              funct_3_w_i;
   wire                                    eq_w_i_h;
   wire                                    gteu_w_i_h;
   wire                                    gtes_w_i_h;
   wire                                    ltu_w_i_h;
   wire                                    lts_w_i_h;
   wire                                    cmp_branch_w_i_h;
   // Output
   wire                                    cond_branch_w_o_h;

   // Data Into Register Intermediates
   wire [31:0]                             alu_mem_w_i;
   wire [31:0]                             imm_or_res_w_i;



   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------

   alu alu_0(/*AUTOINST*/
             // Outputs
             .alu_res_w_o               (alu_res_w_o),
             .eq_w_o_h                  (eq_w_o_h),
             .gteu_w_o_h                (gteu_w_o_h),
             .ltu_w_o_h                 (ltu_w_o_h),
             .gtes_w_o_h                (gtes_w_o_h),
             .lts_w_o_h                 (lts_w_o_h),
             // Inputs
             .a_data_w_i                (a_data_w_i),
             .b_data_w_i                (b_data_w_i),
             .alu_control_w_i           (alu_control_w_i),
             .addi_sub_flag_w_i         (addi_sub_flag_w_i),
             .store_force_add_flag_w_i  (store_force_add_flag_w_i));

   cond_branch_control cbc_0(/*AUTOINST*/
                             // Outputs
                             .cond_branch_w_o_h (cond_branch_w_o_h),
                             // Inputs
                             .funct_3_w_i       (funct_3_w_i),
                             .eq_w_i_h          (eq_w_i_h),
                             .gteu_w_i_h        (gteu_w_i_h),
                             .gtes_w_i_h        (gtes_w_i_h),
                             .ltu_w_i_h         (ltu_w_i_h),
                             .lts_w_i_h         (lts_w_i_h),
                             .cmp_branch_w_i_h  (cmp_branch_w_i_h));

   imm_gen imm_gen_0(/*AUTOINST*/
                     // Outputs
                     .imm_w_o           (imm_w_o),
                     // Inputs
                     .instr_w_i         (instr_w_i));



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
                         .wr_reg_w_i            (wr_reg_w_i),
                         .wr_data_w_i           (wr_data_w_i),
                         .reg_wr_flag_w_i       (reg_wr_flag_w_i));

   control control_0(/*AUTOINST*/
                     // Outputs
                     .reg_write_w_o_h   (reg_write_w_o_h),
                     .alu_src_a_w_o     (alu_src_a_w_o),
                     .alu_src_b_w_o     (alu_src_b_w_o),
                     .mem_wr_w_o_h      (mem_wr_w_o_h),
                     .mem_rd_w_o_h      (mem_rd_w_o_h),
                     .branch_w_o_h      (branch_w_o_h),
                     .mem_to_reg_w_o_h  (mem_to_reg_w_o_h),
                     .jal_w_o_h         (jal_w_o_h),
                     .imm_to_reg_w_o_h  (imm_to_reg_w_o_h),
                     .pc_to_reg_w_o     (pc_to_reg_w_o),
                     .cmp_branch_w_o_h  (cmp_branch_w_o_h),
                     // Inputs
                     .opcode_w_i        (opcode_w_i));


   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   // PC
   assign pc_w_i = branch_res ? alu_res_w_o : (instr_w_o + 4);

   // PC Branch Intermediates
   assign branch_res = branch_w_o_h & (jal_w_o_h | cond_branch_w_o_h);

   // REGISTERS
   assign rd_reg_1_w_i = instr_w_i[19:15];
   assign rd_reg_2_w_i = instr_w_i[24:20];
   assign wr_reg_w_i = instr_w_i[11:7];

   // CONTROL - TOP LEVEL
   assign opcode_w_i = instr_w_i[6:0];
   assign reg_wr_flag_w_i = reg_write_w_o_h;

   // ALU
   assign a_data_w_i = alu_src_a_w_o ? instr_w_o : rd_data_1_w_o;
   assign b_data_w_i = alu_src_b_w_o ? imm_w_o : rd_data_2_w_o;
   assign alu_control_w_i = {instr_w_i[30], instr_w_i[14:12]};
   assign addi_sub_flag_w_i = instr_w_i[5];
   assign store_force_add_flag_w_i = ((instr_w_i[6:0] == 7'b0100011) | (instr_w_i[6:0] == 7'b0000011));

   // CONTROL - CONDITIONAL BRANCH
   assign funct_3_w_i = instr_w_i[14:12];
   assign eq_w_i_h = eq_w_o_h;
   assign gteu_w_i_h = gteu_w_o_h;
   assign gtes_w_i_h = gtes_w_o_h;
   assign ltu_w_i_h = ltu_w_o_h;
   assign lts_w_i_h = lts_w_o_h;
   assign cmp_branch_w_i_h = cmp_branch_w_o_h;

   // Data Into Register Intermediates
   assign wr_data_w_i = imm_to_reg_w_o_h ? imm_w_o : imm_or_res_w_i;
   assign imm_or_res_w_i = pc_to_reg_w_o ? (instr_w_o + 4) : alu_mem_w_i;
   assign alu_mem_w_i = mem_to_reg_w_o_h ? mem_data_w_i : alu_res_w_o;

   // Mem Byte/HW/Word Select
   assign mem_wr_byte_sel_w_o = instr_w_i[14:12];
   assign mem_rd_byte_sel_w_o = instr_w_i[14:12];

   // Data Mem Inputs
   assign mem_addr_in_w_o = alu_res_w_o;
   assign mem_data_in_w_o = rd_data_2_w_o;

endmodule // cpe_cpu

