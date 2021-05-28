//////////////////////////////////////////////////////////////
// baud_gen.sv - baud rate generator for UART
//
// Author:	Roy Kravitz (roy.kravitz@pdx.edu) 
// Date:	20-May-2020
//
// Description:
// ------------
// Implements a programmable counter that is used in the UART
// code for generate the oversampling clock (typically 16x the baud rate)
//
// Original code by Pong Chu from his book FPGA Prototyping w/ SystemVerilog, Wiley 2018
////////////////////////////////////////////////////////////////
module baud_gen (
    input  logic clk, reset,		// system clock and reset
    input  logic [10:0] dvsr,		// divisor for the clock divider
    output logic tick				// one cycle sampling clock signal
   );

   // internal variables
   logic [10:0] r_reg;
   logic [10:0] r_next;

   always_ff @(posedge clk, posedge reset) begin: counter
      if (reset)
         r_reg <= 0;
      else
         r_reg <= r_next;
	end: counter

   // next-state logic - clear counter after overflow
   assign r_next = (r_reg == dvsr) ? '0 : r_reg + 1;
   
   // output logic - one cycle "tick" when counter has counted down
   assign tick = (r_reg==1);
endmodule: baud_gen