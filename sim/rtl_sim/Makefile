all: alu cmp_gen control imm_gen pc registers cond_branch_control cpe_cpu 

alu:
	iverilog -o alu.tb alu_tb.v ../../rtl/verilog/alu.v
	vvp alu.tb

cmp_gen:
	iverilog -o cmp_gen.tb cmp_gen_tb.v ../../rtl/verilog/cmp_gen.v
	vvp cmp_gen.tb

control:
	iverilog -o control.tb control_tb.v ../../rtl/verilog/control.v
	vvp control.tb

cpe_cpu:
	iverilog -o cpe_cpu.tb cpe_cpu_tb.v ../../rtl/verilog/cpe_cpu.v ../../rtl/verilog/alu.v ../../rtl/verilog/control.v ../../rtl/verilog/imm_gen.v ../../rtl/verilog/pc.v ../../rtl/verilog/registers.v ../../rtl/verilog/cond_branch_control.v ../../rtl/verilog/cmp_gen.v
	vvp cpe_cpu.tb

imm_gen:
	iverilog -o imm_gen.tb imm_gen_tb.v ../../rtl/verilog/imm_gen.v
	vvp imm_gen.tb

pc:
	iverilog -o pc.tb pc_tb.v ../../rtl/verilog/pc.v
	vvp pc.tb

registers:
	iverilog -o registers.tb registers_tb.v ../../rtl/verilog/registers.v
	vvp registers.tb

cond_branch_control:
	iverilog -o cond_branch_control.tb cond_branch_control_tb.v ../../rtl/verilog/cond_branch_control.v
	vvp cond_branch_control.tb

alu_wave: alu
	gtkwave alu.vcd

cmp_gen_wave: cmp_gen
	gtkwave cmp_gen.vcd

control_wave: control
	gtkwave control.vcd

cpe_cpu_wave: cpe_cpu
	gtkwave cpe_cpu.vcd

imm_gen_wave: imm_gen
	gtkwave imm_gen.vcd

pc_wave: pc
	gtkwave pc.vcd

registers_wave: registers
	gtkwave registers.vcd

cond_branch_control_wave: cond_branch_control
	gtkwave cond_branch_control.vcd

clean:
	rm -f *.tb *.vcd
