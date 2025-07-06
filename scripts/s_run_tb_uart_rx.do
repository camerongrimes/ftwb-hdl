vlib work
vlog uart_rx.sv testbenches/tb_uart_rx.sv
vsim tb_uart_rx
add wave *
run 100000000ns
wave zoom full