//                              -*- Mode: Verilog -*-
// Filename        : registers_tb.v
// Description     : register tb
// Author          : Patrick
// Created On      : Fri Apr 15 17:26:18 2022
// Last Modified By: Patrick
// Last Modified On: Fri Apr 15 17:26:18 2022
// Update Count    : 0
// Status          : Unknown, Use with caution!

`timescale 1ns/1ps

//-----------------------------------------------------------------------------
// Module Declaration
//-----------------------------------------------------------------------------
module registers_tb (/*AUTOARG*/) ;


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

   //-----------------------------------------------------------------------------
   // Internal Registers and Wires
   //-----------------------------------------------------------------------------
   reg        clk_tb_i;
   reg        res_tb_i_h;
   reg [4:0]  rd_reg_1_tb_i;
   reg [4:0]  rd_reg_2_tb_i;
   reg [4:0]  wr_reg_tb_i;
   reg [31:0] wr_data_tb_i;
   reg        reg_wr_flag_tb_i;


   wire [31:0] rd_data_1_w_o;
   wire [31:0] rd_data_2_w_o;
   wire        clk_w_i;
   wire        res_w_i_h;
   wire [4:0]  rd_reg_1_w_i;
   wire [4:0]  rd_reg_2_w_i;
   wire [4:0]  wr_reg_w_i;
   wire [31:0] wr_data_w_i;
   wire        reg_wr_flag_w_i;

   //-----------------------------------------------------------------------------
   // Instantiations
   //-----------------------------------------------------------------------------
   registers duv(/*AUTOINST*/
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

   //-----------------------------------------------------------------------------
   // RTL
   //-----------------------------------------------------------------------------

   //-----------------------------------------------------------------------------
   // Assigns
   //-----------------------------------------------------------------------------
   assign clk_w_i = clk_tb_i;
   assign res_w_i_h = res_tb_i_h;
   assign rd_reg_1_w_i = rd_reg_1_tb_i;
   assign rd_reg_2_w_i = rd_reg_2_tb_i;
   assign wr_reg_w_i = wr_reg_tb_i;
   assign wr_data_w_i = wr_data_tb_i;
   assign reg_wr_flag_w_i = reg_wr_flag_tb_i;

   //-----------------------------------------------------------------------------
   // Tests
   //-----------------------------------------------------------------------------
   integer     i, errors;
   reg [31:0]  expected_res [31:0];
   always begin
      //TODO ACTUAL CLOCK FREQ
      #1 clk_tb_i = ~clk_tb_i;
   end

   if (TRACE == 1) initial begin
      $dumpfile("registers.vcd");
      $dumpvars;
   end

   initial begin
      clk_tb_i      = 0;
      res_tb_i_h    = 0;
      rd_reg_1_tb_i = 0;
      rd_reg_2_tb_i = 31;
      wr_reg_tb_i   = 0;
      wr_data_tb_i  = 0;
      reg_wr_flag_tb_i      = 0;
      for (i = 0; i < 32; i = i + 1) begin
         expected_res[i] = 0;
      end

      errors         = 0;

      // Assert Reset
      #10 res_tb_i_h = 0;
      #10 res_tb_i_h = 1;
      #10 res_tb_i_h = 0;

      // Test #1: No writes
      for (i = 0; i < NUM_TRIALS; i = i + 1) begin
         // Assert expected values on clock edge
         @ (posedge clk_w_i or posedge res_w_i_h) begin
            if (res_w_i_h) begin
               for (i = 0; i < 32; i = i + 1) begin
                  expected_res[i] <= 0;
               end
            end else begin
               // Update expected result
               if (reg_wr_flag_tb_i) begin
                  expected_res[wr_reg_w_i] <= wr_data_w_i;
               end
               if (expected_res[rd_reg_1_w_i] !== rd_data_1_w_o) begin
                  $display("%d ns: reg_1 error expected:%h received:%h internal reg:%h\n", $time,
                           expected_res[rd_reg_1_w_i], rd_data_1_w_o, rd_reg_1_w_i);
                  errors = errors + 1;
               end
               if (expected_res[rd_reg_2_w_i] !== rd_data_2_w_o) begin
                  $display("%d ns: reg_2 error expected:%h received:%h internal reg:%h\n", $time,
                           expected_res[rd_reg_2_w_i], rd_data_2_w_o, rd_reg_2_w_i);
                  errors = errors + 1;
               end
            end // else: !if(res_w_i_h)
         end

         // Update random values on negedge to simulate combitorial time
         @ (negedge clk_w_i) begin
            rd_reg_1_tb_i = ($random % (1 << 4));
            rd_reg_2_tb_i = ($random % (1 << 4));
            wr_reg_tb_i   = ($random % (1 << 4));
            wr_data_tb_i  = $random;
         end
      end // for (i = 0; i < NUM_TRIALS; i = i + 1)

      // Test #1: Always write
      reg_wr_flag_tb_i      = 1;
      for (i = 0; i < NUM_TRIALS; i = i + 1) begin
         // Assert expected values on clock edge
         @ (posedge clk_w_i or posedge res_w_i_h) begin
            if (res_w_i_h) begin
               for (i = 0; i < 32; i = i + 1) begin
                  expected_res[i] <= 0;
               end
            end else begin
               // Update expected result
               if (reg_wr_flag_tb_i) begin
                  if (wr_reg_w_i != 0) begin// All registers besides zero reg
                     expected_res[wr_reg_w_i] <= wr_data_w_i;
                  end
               end
               if (expected_res[rd_reg_1_w_i] !== rd_data_1_w_o) begin
                  $display("%d ns: reg_1 error expected:%h received:%h internal reg:%h\n", $time,
                           expected_res[rd_reg_1_w_i], rd_data_1_w_o, rd_reg_1_w_i);
                  errors = errors + 1;
               end
               if (expected_res[rd_reg_2_w_i] !== rd_data_2_w_o) begin
                  $display("%d ns: reg_2 error expected:%h received:%h internal reg:%h\n", $time,
                           expected_res[rd_reg_2_w_i], rd_data_2_w_o, rd_reg_2_w_i);
                  errors = errors + 1;
               end
            end // else: !if(res_w_i_h)
         end

         // Update random values on negedge to simulate combitorial time
         @ (negedge clk_w_i) begin
            rd_reg_1_tb_i = ($random % (1 << 4));
            rd_reg_2_tb_i = ($random % (1 << 4));
            wr_reg_tb_i   = ($random % (1 << 4));
            wr_data_tb_i  = $random;
         end
      end // for (i = 0; i < NUM_TRIALS; i = i + 1)

      // Test #2: Randomly update write on negedge clk
      for (i = 0; i < NUM_TRIALS; i = i + 1) begin
         // Assert expected values on clock edge
         @ (posedge clk_w_i or posedge res_w_i_h) begin
            if (res_w_i_h) begin
               for (i = 0; i < 32; i = i + 1) begin
                  expected_res[i] <= 0;
               end
            end else begin
               // Update expected result
               if (reg_wr_flag_tb_i) begin
                  if (wr_reg_w_i != 0) begin// All registers besides zero reg
                     expected_res[wr_reg_w_i] <= wr_data_w_i;
                  end
               end
               if (expected_res[rd_reg_1_w_i] !== rd_data_1_w_o) begin
                  $display("%d ns: reg_1 error expected:%h received:%h internal reg:%h\n", $time,
                           expected_res[rd_reg_1_w_i], rd_data_1_w_o, rd_reg_1_w_i);
                  errors = errors + 1;
               end
               if (expected_res[rd_reg_2_w_i] !== rd_data_2_w_o) begin
                  $display("%d ns: reg_2 error expected:%h received:%h internal reg:%h\n", $time,
                           expected_res[rd_reg_2_w_i], rd_data_2_w_o, rd_reg_2_w_i);
                  errors = errors + 1;
               end
            end // else: !if(res_w_i_h)
         end

         // Update random values on negedge to simulate combitorial time
         @ (negedge clk_w_i) begin
            rd_reg_1_tb_i = ($random % (1 << 4));
            rd_reg_2_tb_i = ($random % (1 << 4));
            wr_reg_tb_i   = ($random % (1 << 4));
            wr_data_tb_i  = $random;
            reg_wr_flag_tb_i = ($random % 2);
         end
      end // for (i = 0; i < NUM_TRIALS; i = i + 1)


      $display("%d ns: finished with %d errors over %d trials\n", $time, errors, NUM_TRIALS);
      $finish;
   end

endmodule // registers_tb

