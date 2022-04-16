all: alu_control alu control cpe_cpu imm_gen pc registers

alu_control:
	iverilog -o alu_control.tb alu_control_tb.v ../../rtl/verilog/alu_control.v
	vvp alu_control.tb

alu:
	iverilog -o alu.tb alu_tb.v ../../rtl/verilog/alu.v
	vvp alu.tb

control:
	iverilog -o control.tb control_tb.v ../../rtl/verilog/control.v
	vvp control.tb

cpe_cpu:
	iverilog -o cpe_cpu.tb cpe_cpu_tb.v ../../rtl/verilog/cpe_cpu.v
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

alu_control_wave: alu_control
	gtkwave alu_control.vcd

alu_wave: alu
	gtkwave alu.vcd

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

clean:
	rm -f *.tb *.vcd
