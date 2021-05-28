//////////////////////////////////////////////////////////////
// uart_tx.sv - UART Transmitter (starter code)
//
// Author:	<your name> (<your email address>) 
// Date:	<date>
//
// Description:
// ------------
// Serializes a data packet, adds the start and stop bits and transmits the
// data packed on bit at a time on the tx signal.
//
////////////////////////////////////////////////////////////////
module uart_tx
(
	input  logic clk, reset,            // system clock and reset (reset asserted high)
	input  logic tx_start, s_tick,      // tx_start tells the transmitter to transmit a serial data packet
	input  logic [7:0] din,             // parallel data in
    output logic tx_done_tick,          // packet transmission done pulse
	output logic tx,                    // serial transmit line
    
    output logic xmit_tick              // debug signal for when bit is transmitt3ed
);

// ADD YOUR CODE HERE

endmodule: uart_tx