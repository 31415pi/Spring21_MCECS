
/*  Assignment:				Homework 3
 *  Filename:				ECE351_HW3/FIN/part1/ECE351SP21_HW3_RELEASE_R1_0_PROB_1_FINISHED.SV
 *  					Portland State University
 *  ECE 362: 				Verilog and FPGA Design
 *  Term: 				Spring 2021
 *  Proffessor: 			Prof. Roy Kravitz
 *  T/A:				Tyler Hull
 *  Grader:				Tiffani Shilts Hartman
 *  CRN: 				61016
 *  Student: 				Mx. Madison Uxia Klementyn
 *  Creation Date: 			20.05.2021
 *  Due Date:				24.05.2021 - 1700 hours
 *  Estimated Completion:  		3 hours; final revamp/remake was about 10mins
 *  Notable Fact: 			BTC Hits a market double correction I predicted about 3 months ago. Yup.
 *  References 				Sutherland.
 *  &links:
 */

module fourbitsr 				// begin the module
	(	input logic clk, rstN, sin, sht	// define our ports
		output logic [0:3] q, parout);	// since there is no delay we can just call the shift
						// regs an array of qs, and a 4 bit aray of parallel outs to read em
	timeunit 1ns; timeprecision 0ns;	// set time unit. change timeprecision to adjust clock-to-q
	always_ff @ (posedge clk)		// aka the propagation delay. now start the always block on clock high
		if (rstN) q <= '0;		// synchronous active-high reset when rstN is high, q's reset
		else if (sht) q <= {sin, q[3:1];// shift asserts- append serial in to q as the other bits shift. drops last
	assign parout <= q;			// keep parallel ports actively updated
endmodule fourbitsr				// endmodule
