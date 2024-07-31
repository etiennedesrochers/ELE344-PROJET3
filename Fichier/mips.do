vlib work 

vcom -93 -work work unite.vhd
vcom -93 -work work mux2.vhd
vcom -93 -work work mux3.vhd
vcom -93 -work work pc.vhd
vcom -93 -work work pcplus4.vhd
vcom -93 -work work regfile.vhd
vcom -93 -work work ual.vhd
vcom -93 -work work datapath.vhd
vcom -93 -work work control.vhd
vcom -93 -work work mips.vhd
vcom -93 -work work imem.vhd
vcom -93 -work work dmem.vhd
vcom -93 -work work top.vhd

vsim Top
add wave -position end  sim:/top/clk
add wave -position end  sim:/top/reset
add wave -position end  sim:/top/PC(9:2)
add wave -position end  sim:/top/Instruction
add wave -position end  sim:/top/AluResult
add wave -position end  sim:/top/WRITEDATA

--add wave -position end  sim:/top/mips_inst/data_path_inst/ID_EX_rd1
--add wave -position end  sim:/top/mips_inst/data_path_inst/EX_MEM_AluResult
--add wave -position end  sim:/top/mips_inst/data_path_inst/WB_Result
--add wave -position end  sim:/top/mips_inst/data_path_inst/EX_SrcA
--add wave -position end  sim:/top/mips_inst/data_path_inst/EX_SrcB
--add wave -position end  sim:/top/mips_inst/data_path_inst/ID_rd1
--add wave -position end  sim:/top/mips_inst/data_path_inst/ID_rd2
add wave -position end  sim:/top/mips_inst/data_path_inst/ID_EX_AluControl
add wave -position end  sim:/top/mips_inst/data_path_inst/MEM_WB_MemtoReg
add wave -position end  sim:/top/mips_inst/data_path_inst/EX_ForwardA
add wave -position end  sim:/top/mips_inst/data_path_inst/EX_ForwardB
add wave -position end  sim:/top/mips_inst/data_path_inst/EX_SrcA
add wave -position end  sim:/top/mips_inst/data_path_inst/EX_SrcB
force /top/clk 1,0 10 ns -repeat 20 ns
force /top/reset 1,0 15 ns
run 650 ns



