
# Compile the design and test bench files
vlib work
vcom -93 -work work unite.vhd
vcom -93 -work work unite_tb.vhd

# Simulate the test bench
vsim work.unite_tb

# Set up wave window (optional, for better visualization)
view wave
add wave *

# Run the simulation for a specified time (e.g., 100 ns)
run 100 ns

# End the simulation
