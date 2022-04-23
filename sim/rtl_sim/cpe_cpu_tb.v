//                              -*- Mode: Verilog -*-
// Filename        : cpe_cpu_tb.v
// Description     : cpe cpu top level tb
// Author          : Patrick
// Created On      : Fri Apr 15 17:13:24 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:13:24 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ps

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module cpe_cpu_tb (/*AUTOARG*/) ;

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
   parameter DELAY = 5;   // TODO Determine Actual
   // Mem width needs to be shorter for simulation to run
   parameter MEM_WIDTH = 16 - 1; // Mem Length - 1

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   wire [31:0] mem_data_in_w_o;
   wire [31:0] mem_addr_in_w_o;
   wire [31:0] instr_w_o;
   wire        mem_wr_w_o_h;
   wire        mem_rd_w_o_h;
   wire [1:0]  mem_wr_byte_sel_w_o;
   wire [1:0]  mem_rd_byte_sel_w_o;

   reg         clk_tb_i;
   reg         res_tb_i_h;
   reg [31:0]  instr_tb_i;
   reg [31:0]  mem_data_tb_i;

   wire        clk_w_i;
   wire        res_w_i_h;
   wire [31:0] instr_w_i;
   wire [31:0] mem_data_w_i;

   // Tool doesn't like having a full 32 bit address space
   // I'll less bits and say last bits are unmapped/memory mapped stuff
   // For future peripheral mapping
   reg [7:0]   instr_mem [(1 << MEM_WIDTH) - 1:0];
   reg [7:0]   data_mem [(1 << MEM_WIDTH) - 1:0];

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   cpe_cpu duv(/*AUTOINST*/
               // Outputs
               .mem_data_in_w_o         (mem_data_in_w_o),
               .mem_addr_in_w_o         (mem_addr_in_w_o),
               .instr_w_o               (instr_w_o),
               .mem_wr_w_o_h            (mem_wr_w_o_h),
               .mem_rd_w_o_h            (mem_rd_w_o_h),
               .mem_wr_byte_sel_w_o     (mem_wr_byte_sel_w_o),
               .mem_rd_byte_sel_w_o     (mem_rd_byte_sel_w_o),
               // Inputs
               .clk_w_i                 (clk_w_i),
               .res_w_i_h               (res_w_i_h),
               .instr_w_i               (instr_w_i),
               .mem_data_w_i            (mem_data_w_i));

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign clk_w_i = clk_tb_i;
   assign res_w_i_h = res_tb_i_h;
   //assign instr_w_i = instr_tb_i;
   assign mem_data_w_i = mem_data_tb_i;

   // 4 Bytes from address => Actual Data
   // Don't use full bus for sim to keep it possible
   assign instr_w_i = {instr_mem[instr_w_o[MEM_WIDTH:0]],
                        instr_mem[(instr_w_o[MEM_WIDTH:0]) + 1],
                        instr_mem[(instr_w_o[MEM_WIDTH:0]) + 2],
                       instr_mem[(instr_w_o[MEM_WIDTH:0]) + 3]};


   //-----------------------------------------------------------------------------
   // Tasks
   //-----------------------------------------------------------------------------
   integer     j;
   task reset_mem;
      begin
         for (j = 0; j < ((1 << MEM_WIDTH)); j = j + 1) begin
            instr_mem[j] <= 8'h00;
            data_mem[j]  <= j % 256; // Store 0x0, 0x1, 0x2, etc.
         end
         #DELAY;
      end
   endtask // reset_mem

   task reset_dut;
      begin
         repeat (10) #DELAY;
         res_tb_i_h = 0;
         repeat (10) #DELAY;
         res_tb_i_h = 1;
         repeat (10) #DELAY;
         res_tb_i_h = 0;
         $display("Setting reset_done");
         reset_done = 1;
         repeat (10) #DELAY;
      end
   endtask // reset_dut

   task add_instr(input [MEM_WIDTH:0] instr_addr, input [31:0] instr);
      begin
         //instr_mem[instr_addr] = instr[31:24];
         $display("ADDING INSTR:%h TO LOCATION:%h\n", instr, instr_addr);
         instr_mem[instr_addr] = instr[31:24];
         instr_mem[instr_addr + 1] = instr[23:16];
         instr_mem[instr_addr + 2] = instr[15:8];
         instr_mem[instr_addr + 3] = instr[7:0];
         curr_instr = instr_addr + 4;
         #DELAY;
      end
   endtask // add_instr

   task display_i_type;
      begin
         $display("%d ns: Cycle:%d Addr:%d Res:%d", $time, cycle, duv.wr_reg_w_i, $signed(duv.wr_data_w_i));
      end
   endtask // display_i_type

   task display_r_type;
      begin
         $display("%d ns: Cycle:%d Addr:%d Res:%d", $time, cycle, duv.wr_reg_w_i, $signed(duv.wr_data_w_i));
      end
   endtask // display_r_type

   task display_s_type;
      begin
         $display("%d ns: Cycle:%d Wr_Sel:%b Data:%d Addr:%d ", $time, cycle, mem_wr_byte_sel_w_o,
                  mem_data_in_w_o, mem_addr_in_w_o);
      end
   endtask // display_s_type

   task display_load_type;
      begin
         $display("%d ns: Cycle:%d Wr_Sel:%b Data:%d Addr:%d ", $time, cycle, mem_wr_byte_sel_w_o,
                  mem_data_w_i, mem_addr_in_w_o);
      end
   endtask // display_load_type

   task display_b_type;
      begin
         #DELAY;
         $display("%d ns: Cycle:%d New PC:%d Old PC:%d", $time, cycle, duv.instr_w_o, duv.pc_w_i);
      end
   endtask // display_b_type

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   if (TRACE == 1) initial begin
      $dumpfile("cpe_cpu.vcd");
      $dumpvars;
   end

   always @ (posedge clk_tb_i) begin
      cycle <= cycle + 1;
      if (i_type) begin
         display_i_type();
         if (cycle == 21) begin
            $display("%d ns: I Type Complete\n", $time);
            i_type = 0;
            r_type = 1;
         end
      end else if (r_type) begin
         display_r_type();
         if (cycle == 50) begin
            $display("%d ns: R Type Complete\n", $time);
            r_type = 0;
            s_type = 1;
         end
      end else if (s_type) begin
         display_s_type();
         if (cycle == 57) begin
            $display("%d ns: S Type Complete\n", $time);
            s_type = 0;
            load_type = 1;
         end
      end else if (load_type) begin
         display_load_type();
         if (cycle == 64) begin
            $display("%d ns: S Type Complete\n", $time);
            load_type = 0;
            b_type = 1;
         end
      end else if (b_type) begin
         display_b_type();
         if (cycle == 81) begin
            $display("%d ns: B Type Complete\n", $time);
            b_type = 0;
            // TODO NEXT TYPE
         end
      end
   end


   always begin
      #DELAY if(reset_done) begin
         if (initial_delay_done) begin
            clk_tb_i = ~clk_tb_i;
         end else begin
            repeat (10) #DELAY;
            initial_delay_done = 1;
            i_type             = 1;
         end
      end
   end


   integer reset_done, initial_delay_done, curr_instr, cycle;
   integer i_type, r_type, s_type, load_type, b_type;
   initial begin
      clk_tb_i           = 0;
      res_tb_i_h         = 0;
      instr_tb_i         = 0;
      mem_data_tb_i      = 0;
      cycle              = 1;
      reset_done         = 0;
      initial_delay_done = 0;
      curr_instr         = 0;
      i_type             = 0;
      r_type             = 0;
      s_type             = 0;
      load_type = 0;
      mem_data_tb_i = 1;
      reset_mem();
      // Consult Test Spreadsheet to see expected results on each clock cycle
      // Immediate Instructions Tests
      //=======================imm_____________rs1___ff3_rd____opcode_======INST RD, RS1, IMM
      add_instr(curr_instr, 32'b0000_0000_0001_00000_000_00001_0010011); // ADDI 0x1, 0x0, 1
      add_instr(curr_instr, 32'b0000_0000_0001_00001_000_00010_0010011); // ADDI 0x2, 0x1, 1
      add_instr(curr_instr, 32'b0000_0000_0010_00010_000_00011_0010011); // ADDI 0x3, 0x2, 2
      add_instr(curr_instr, 32'b1111_1111_1011_00011_000_00100_0010011); // ADDI 0x4, 0x3, -5

      add_instr(curr_instr, 32'b0000_0000_0010_00001_010_00101_0010011); // SLTI 0x5, 0x1, 2
      add_instr(curr_instr, 32'b1111_1111_1111_00001_010_00110_0010011); // SLTI 0x6, 0x1, -1

      add_instr(curr_instr, 32'b0000_0000_0000_00001_011_00111_0010011); // SLTIU 0x7, 0x1, 0
      add_instr(curr_instr, 32'b1111_1111_1111_00001_011_01000_0010011); // SLTIU 0x8, 0x1, -1

      add_instr(curr_instr, 32'b0000_0000_0010_00001_100_01001_0010011); // XORI 0x9, 0x1, 2
      add_instr(curr_instr, 32'b0000_0000_0001_00001_100_01010_0010011); // XORI 0xA, 0x1, 1

      add_instr(curr_instr, 32'b0000_0000_0001_00001_110_01011_0010011); // ORI 0xB, 0x1, 1
      add_instr(curr_instr, 32'b0000_0000_0110_00001_110_01100_0010011); // ORI 0xC, 0x1, 6

      add_instr(curr_instr, 32'b0000_0000_0001_00001_001_01101_0010011); // SLLI 0xD, 0x1, 1

      add_instr(curr_instr, 32'b0000_0000_0001_00001_101_01110_0010011); // SRLI 0xE, 0x1, 1
      add_instr(curr_instr, 32'b0000_0000_0001_00010_101_01111_0010011); // SRLI 0xF, 0x2, 1

      add_instr(curr_instr, 32'b0100_0000_0001_00001_101_10000_0010011); // SRAI 0x10, 0x1, 1
      add_instr(curr_instr, 32'b0100_0000_0001_00010_101_10001_0010011); // SRAI 0x11, 0x2, 1
      add_instr(curr_instr, 32'b0100_0000_0001_00100_101_10010_0010011); // SRAI 0x12, 0x4, 1

      add_instr(curr_instr, 32'b0000_0000_0001_00001_111_10011_0010011); // ANDI 0x13, 0x1, 1
      add_instr(curr_instr, 32'b0000_0000_0000_00001_111_10100_0010011); // ANDI 0x13, 0x1, 0
      add_instr(curr_instr, 32'b1111_1111_1111_00001_111_10101_0010011); // ANDI 0x13, 0x1, 0xFFF

      // R Type Instructions Tests
      //====================ff7_________rs2___rs1___ff3_rd____opcode_======INST RD, RS1, RS2
      add_instr(curr_instr, 32'b0000_000_00000_00001_000_10110_0110011); // ADD 22, 1, 0
      add_instr(curr_instr, 32'b0000_000_00000_00100_000_10111_0110011); // ADD 23, 4, 0

      add_instr(curr_instr, 32'b0100_000_00000_00001_000_11000_0110011); // SUB 24, 1, 0
      add_instr(curr_instr, 32'b0100_000_00001_00000_000_11001_0110011); // SUB 25, 0, 1
      add_instr(curr_instr, 32'b0100_000_00001_00011_000_11010_0110011); // SUB 26, 3, 1

      add_instr(curr_instr, 32'b0100_000_00001_00001_001_11011_0110011); // SLL 27, 1, 1
      add_instr(curr_instr, 32'b0100_000_00000_00001_001_11100_0110011); // SLL 28, 1, 0
      add_instr(curr_instr, 32'b0100_000_00011_00010_001_11101_0110011); // SLL 29, 2, 3

      add_instr(curr_instr, 32'b0000_000_00000_00001_010_11110_0110011); // SLT 30, 1, 0
      add_instr(curr_instr, 32'b0000_000_00001_00000_010_11111_0110011); // SLT 31, 0, 1
      add_instr(curr_instr, 32'b0000_000_00000_00100_010_10110_0110011); // SLT 22, 4, 0
      add_instr(curr_instr, 32'b0000_000_00010_00100_010_10111_0110011); // SLT 23, 4, 2

      add_instr(curr_instr, 32'b0000_000_00000_00001_011_11000_0110011); // SLTU 24, 1, 0
      add_instr(curr_instr, 32'b0000_000_00001_00000_011_11001_0110011); // SLTU 25, 0, 1
      add_instr(curr_instr, 32'b0000_000_00000_00100_011_11010_0110011); // SLTU 26, 4, 0

      add_instr(curr_instr, 32'b0000_000_00011_00000_100_11011_0110011); // XOR 27, 0, 3
      add_instr(curr_instr, 32'b0000_000_00011_00001_100_11100_0110011); // XOR 28, 1, 3

      add_instr(curr_instr, 32'b0000_000_00000_00001_101_11101_0110011); // SRL 29, 1, 0
      add_instr(curr_instr, 32'b0000_000_00001_00010_101_11110_0110011); // SRL 30, 2, 1
      add_instr(curr_instr, 32'b0000_000_00001_00100_101_11111_0110011); // SRL 31, 4, 1

      add_instr(curr_instr, 32'b0100_000_00000_00001_101_10110_0110011); // SRA 22, 1, 0
      add_instr(curr_instr, 32'b0100_000_00001_00010_101_10111_0110011); // SRA 23, 2, 1
      add_instr(curr_instr, 32'b0100_000_00001_00100_101_11000_0110011); // SRA 24, 4, 1

      add_instr(curr_instr, 32'b0000_000_00000_00001_110_11001_0110011); // OR 25, 1, 0
      add_instr(curr_instr, 32'b0000_000_00001_00010_110_11010_0110011); // OR 26, 2, 1
      add_instr(curr_instr, 32'b0000_000_00001_00001_110_11011_0110011); // OR 27, 1, 1

      add_instr(curr_instr, 32'b0000_000_00001_00001_111_11100_0110011); // AND 28, 1, 1
      add_instr(curr_instr, 32'b0000_000_00000_00001_111_11101_0110011); // AND 29, 1, 0
      add_instr(curr_instr, 32'b0000_000_01001_00001_111_11110_0110011); // AND 30, 1, 9

      // S Type Instructions Tests
      //=======================imm[11:5]_rs2___rs1___ff3_imm[4:0]opcode=====INST RS2, OFFSET(RS1)
      add_instr(curr_instr, 32'b0000_000_00001_00000_000_00000_0100011); // SB 1, 0(0)
      add_instr(curr_instr, 32'b0000_000_00001_00000_000_00001_0100011); // SB 1, 1(0)
      add_instr(curr_instr, 32'b0000_000_00001_00000_000_00010_0100011); // SB 1, 2(0)
      add_instr(curr_instr, 32'b0000_000_00001_00000_000_00011_0100011); // SB 1, 3(0)

      add_instr(curr_instr, 32'b0000_000_00001_00000_001_00000_0100011); // SH 1, 0(0)
      add_instr(curr_instr, 32'b0000_000_00001_00000_001_00010_0100011); // SH 1, 2(0)

      add_instr(curr_instr, 32'b0000_000_00001_00000_010_00000_0100011); // SW 1, 0(0)

      // I Type Instructions - Load Case - Tests
      //=======================imm_____________rs1___ff3_rd____opcode_======INST rd, offset(rs1)
      add_instr(curr_instr, 32'b0000_0000_0000_00000_000_11010_0000011); // LB 26, 0(0)
      add_instr(curr_instr, 32'b0000_0000_0001_00000_000_11011_0000011); // LB 27, 1(0)
      add_instr(curr_instr, 32'b0000_0000_0010_00000_000_11100_0000011); // LB 28, 2(0)
      add_instr(curr_instr, 32'b0000_0000_0011_00000_000_11101_0000011); // LB 29, 3(0)

      add_instr(curr_instr, 32'b0000_0000_0000_00000_001_11110_0000011); // LH 30, 0(0)
      add_instr(curr_instr, 32'b0000_0000_0010_00000_001_11111_0000011); // LH 31, 2(0)

      add_instr(curr_instr, 32'b0000_0000_0000_00000_010_11111_0000011); // LW 22, 0(0)

      // B Type Instructions Tests
      //=====================mm[12|10:5]_rs2___rs1___ff3_imm[4:1|11]_opcode=====INST RS1, RS2, IMM
      add_instr(curr_instr, 32'b0000_000_00000_00000_000_01000_1100011); // BEQ 0, 0, 8
      add_instr(curr_instr + 4, 32'b0000_000_00001_00000_000_01000_1100011); // BEQ 0, 1, 8

      add_instr(curr_instr, 32'b0000_000_00000_00000_001_01000_1100011); // BNEQ 0, 0, 8
      add_instr(curr_instr, 32'b0000_000_00001_00000_001_01000_1100011); // BNEQ 0, 1, 8

      add_instr(curr_instr + 4, 32'b0000_000_00000_00000_100_01000_1100011); // BLT 0, 0, 8
      add_instr(curr_instr, 32'b0000_000_00001_00000_100_01000_1100011); // BLT 0, 1, 8
      add_instr(curr_instr + 4, 32'b0000_000_00000_00100_100_01000_1100011); // BLT 4, 0, 8

      add_instr(curr_instr + 4, 32'b0000_000_00000_00000_101_01000_1100011); // BGE 0, 0, 8
      add_instr(curr_instr + 4, 32'b0000_000_00000_00001_101_01000_1100011); // BGE 1, 0, 8
      add_instr(curr_instr + 4, 32'b0000_000_00000_00100_101_01000_1100011); // BGE 4, 0, 8

      add_instr(curr_instr, 32'b0000_000_00000_00000_110_01000_1100011); // BLTU 0, 0, 8
      add_instr(curr_instr, 32'b0000_000_00001_00000_110_01000_1100011); // BLTU 0, 1, 8
      add_instr(curr_instr + 4, 32'b0000_000_00000_00100_110_01000_1100011); // BLTU 4, 0, 8

      add_instr(curr_instr + 4, 32'b0000_000_00000_00000_111_01000_1100011); // BGEU 0, 0, 8
      add_instr(curr_instr + 4, 32'b0000_000_00000_00001_111_01000_1100011); // BGEU 1, 0, 8
      add_instr(curr_instr + 4, 32'b0000_000_00000_00100_111_01000_1100011); // BGEU 4, 0, 8
      add_instr(curr_instr + 4, 32'b0000_000_00001_00000_111_01000_1100011); // BGEU 0, 1, 8

      reset_dut();

      #1500 $display("%d ns: finished ERRORS must be counted by hand\n", $time);
      #10 $finish;
   end


endmodule // cpe_cpu_tb

