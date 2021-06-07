//////////////////////////////////////////////////////////////////////////////
// tb_uart_loopback.sv -  UART unit level loopback test  
//
// Author:	Roy Kravitz (roy.kravitz@pdx.edu)
// Date:	6/2/2020 
//
// Description:
// ------------
// Unit level Test bench for UART receiver and transmitter.  Loops the
// Tx and Rx lines together and sends data.  Results are checked at the
// receiver.
//
// Generates all characters from 0x00 to 0x7F in TX RX loopback test
////////////////////////////////////////////////////////////////////////////

module tb_uart_loopback;

timeunit 1ns/1ns;

// make use of the SystemVerilog C programming interface
// https://stackoverflow.com/questions/33394999/how-can-i-know-my-current-path-in-system-verilog
import "DPI-C" function string getenv(input string env_name);

// parameters
parameter SYS_CLK_FREQ	= 50_000_000; 		    		// Assume 50 MHz system clk	
parameter CLK_PERIOD	= 20;							// 50 MHz is  20ns clk period 
parameter CYCLES        = 10;							// delay cycles	
		 
parameter BAUD_RATE		= 19200;						// Baud rate (bits per second)
parameter DBITS			= 8;							// Number of data bits
parameter STOPBITS		= 1;							// Number of stop bits
parameter PARITY		= 0;							// Does not support parity

localparam TICKS	= SYS_CLK_FREQ / BAUD_RATE;			// for baud rate of 19200, TICKS = 2604
localparam DVSR		= SYS_CLK_FREQ / BAUD_RATE / 16;	// divisor for setting baud rate
localparam SB_TICKS	= STOPBITS * 16;					// number of ticks for stop bit

// internal variables
logic 			clk, reset;			// system clock and reset
logic [10:0] 	dvsr;				// divisor for baud rate generator
logic [7:0]		din_reg;			// register holding data to transmit
logic [7:0]		dout_reg;			// register holding last data received
logic [7:0]		rx_data;			// received data
logic			tick; 				// single cycle tick signal from baud rate generator

logic			tx_start, tx_done;	// start and packet transmitted to/from transmitter
logic			rx_done;			// rx_done from receiver when packet received

logic			tx, rx;				// serial transmit and serial receive
int				error_count = 0;	// error count
logic			match;				// expected and transmitted data match
logic			xmit_tick, smpl_tick;	//debug signals
	
// loop tx to rx (this is the loopback)
assign rx = tx;

// instantiate the modules
// Baud Rate generator
baud_gen BRG
(
	.clk(clk),
	.reset(reset),
    .dvsr(dvsr),
    .tick(tick)
);

// Transmitter
uart_tx TXMTR
(
	.clk(clk),
	.reset(reset),
	.tx_start(tx_start),
	.s_tick(tick),
	.din(din_reg),
	.tx_done_tick(tx_done),
	.tx(tx),
    .xmit_tick(xmit_tick)
);

// Receiver
uart_rx RCVR
(
	.clk(clk),
	.reset(reset),
    .rx(rx),
	.s_tick(tick),
    .rx_done_tick(rx_done),
    .dout(rx_data),
	.smpl_tick(smpl_tick)
);


// Define some useful tasks

// apply and lift reset after some time so that signals get settled to known values
task apply_reset();
	reset = 1;
	repeat(CYCLES) @(posedge clk);
	reset = 0;
	$display("System Reset");
endtask: apply_reset

// set baud rate by writing divisor register in the BRG 
task set_baud_rate(input int data);
	dvsr = data; 
	$display("baud rate divisor set to %d", dvsr);
endtask : set_baud_rate

// transmit a data packet
task send_packet(input logic[7:0] data);
	din_reg = data;
	repeat(CYCLES/2) @(posedge clk);
	tx_start = 1'b1;
	repeat(CYCLES/2)@(posedge clk);
	tx_start = 1'b0;
endtask: send_packet

// receive a data packet
task receive_packet(input logic[7:0] exp_data, output logic match);
	wait(rx_done);		// wait until data packet received
	dout_reg = rx_data;
	match = dout_reg == exp_data;	// see if the data bits match
	if (match)
		$display("MATCH: received data: %b, expected data: %b",
			rx_data, exp_data);
	else begin
		$display("MISMATCH!!: received data: %b, expected data: %b",
			rx_data, exp_data);
		error_count++;
	end;
	
	// Since tx is looped to rx, the receiver starts to receive
	// the packet before the transmitter has generated tx_done
	// We want so make sure we wait until the transmitter has sent
	// the STOP bit before we start sending the next packet
	wait(tx_done);
endtask: receive_packet

// generate the clock
initial begin: clock_generator
	clk = 0;
	forever #(CLK_PERIOD/2) clk = ~clk;
end: clock_generator

// stimulate the DUT by transmitting data packets and
initial begin: stimulus
	byte snd_data;
    
    $display("\nUART Loopback Test - <your name> (<your email address>)");
    $display("Sources: %s\n", getenv("PWD"));   
	
	apply_reset();
	
/*** Shorten the time between s_ticks
	set_baud_rate(DVSR);
***/
set_baud_rate(20);
	
	// transmit some bytes
	snd_data = byte'($urandom_range(0, 255));
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	snd_data = byte'($urandom_range(0, 255));
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	snd_data = byte'($urandom_range(0, 255));
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	snd_data = 8'b01010101;
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	snd_data = 8'b00000000;
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	snd_data = 8'b10101010;
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	snd_data = 8'b11111111;
	send_packet(snd_data);
	receive_packet(snd_data, match);
	repeat(CYCLES/2) @(posedge clk);
	
	// all done - summarize results
	if (error_count == 0)
		$display("All tests passed");
	else
		$display("%d tests failed", error_count);
		
	repeat(CYCLES) @(posedge clk);
    
    $display("End UART Loopback test - <your name> (<your email address>)\n");
	$stop;
end: stimulus

endmodule: tb_uart_loopback

	
	
	
			
