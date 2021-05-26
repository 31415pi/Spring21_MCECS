/*  Assignment:				Homework 3
 *  Filename:				ECE351_HW3/FIN/part3/ECE351SP21_HW3_RELEASE_R1_0_PROB_3_PMODSSD_EMU.SV
 *  					Portland State University
 *  ECE 362: 				Verilog and FPGA Design
 *  Term: 				Spring 2021
 *  Proffessor: 			Prof. Roy Kravitz
 *  T/A:				Tyler Hull
 *  Grader:				Tiffani Shilts Hartman
 *  CRN: 				61016
 *  Student: 				Mx. Madison Uxia Klementyn
 *  Creation Date: 			22.05.2021
 *  Due Date:				24.05.2021 - 1700 hours
 *  Estimated Completion:  		1 hour prep,
 *  Notable Fact: 			
 *  References 				Sutherland. 
 *  &links:			
 */
module pmodSSD_Interface
	import CHAR_ROULETTE::*;
	#(	SIMULATE = 1	)	

	(input logic clk, reset,		//define our ports.
	input logic[4:0] digit1, digit0,
	output logic SSD_AG, SSD_AF, SSD_AE, SSD_AD, SSD_AC,SSD_AB, SSD_AA, 
	output logic SSD_C	);
 	timeunit 1ns/1ns;

	dig_atttor CLK_ATTENU// instantiate the digital attenuator
		(	.clk(clk),
			.reset(reset),
			.tick_60Hz(SSD_C)	);
 
	//assign SSD_C = tick_60Hz;// THIS IS DONE DURING INSTANTIATION
	initial
		begin
			$monitor($time, "MY OWN PRISON: digits: %h %h SSD_C- %b",digit0, digit1, SSD_C);
		end

	//Lets fire up that SSD!
	always_latch 
		begin
			if (~SSD_C) 
				begin
					{SSD_AA, SSD_AB, SSD_AC, SSD_AD, SSD_AE, 
								SSD_AF, SSD_AG} = BtS(digit0);
								//we get signal, main screeen turn on.
								//TB gives us a 5 dig, we convert it to binary
				end
			else// if (SSD_C)
				begin
					{SSD_AA, SSD_AB, SSD_AC, SSD_AD, SSD_AE, 
					SSD_AF, SSD_AG} = BtS(digit1);
				end
		end

endmodule : pmodSSD_Interface