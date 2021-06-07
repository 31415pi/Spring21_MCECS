
/*  Assignment:				Homework 3
 *  Filename:				ECE351_HW3/FIN/part1/ECE351SP21_HW3_RELEASE_R1_0_PROB_2_FINISHED.SV
 *  					Portland State University
 *  ECE 362: 				Verilog and FPGA Design
 *  Term: 				Spring 2021
 *  Proffessor: 			Prof. Roy Kravitz
 *  T/A:				Tyler Hull
 *  Grader:				Tiffani Shilts Hartman
 *  CRN: 				61016
 *  Student: 				Mx. Madison Uxia Klementyn
 *  Creation Date: 			21.05.2021
 *  Due Date:				24.05.2021 - 1700 hours
 *  Estimated Completion:  		1 hr brush up, 1 hr so far.
 *  Notable Fact: 			LOL They are saying the BTC correction is to "Bankrupt 1 person", while quietly ALL BANKS are mass adopting BTC. BUY NOW.
 *  References 				Sutherland. 
 *  &links:			
 */
 
// Encode using gray code. 8.2.2 State encoding , Sutherland, pg 302, PDF page 325.
typedef enum logic [2:0]	
{
	S0 :	3'b000,
	S1 :	3'b001,
	S2 :	3'b011,
	S3 :	3'b010,
	S4 :	3'b110
} gray_states_t;	

module carwash_fam (
input logic clk, CLR, // clock and reset signal. CLR is asserted high// to reset the FSM
input logic TOKEN, // customer inserted a token. Asserted high
input logic START, // customer pressed the START button. Asserted high
input logic T1DONE, // spray time has expired. Asserted high
input logic T2DONE, // rinse time (after soap) has expired. Asserted// high
output logic CLRT1, // clear the spray timer. Assert high
output logic CLRT2, // clear the rinse timer. Assert high
output logic SOAP, // apply soap. Assert high
output logic SPRAY // turn on the spray. Assert high
);

timeunit 1ns; timeprecision 300ns;	// set time unit. set a propogation delay of 300ns
gray_states_t present, next;
present = S0;				// set state at S0 when first loading module.

always_ff @(posedge clk or negedge CLR)	//current state logic
	if (CLR) present <= S0;
	else present <= next;
	
always_comb begin			// Next state logic
	unique case (present)
	S0 :	next =  (TOKEN) ? S1 : s0 ;	// first set next
	S1 :	next =	(START) ? S4 : (TOKEN && ~START) ?	S2 : S4;	// We have the second money
	S2 :	if (~T1DONE) 				next = S2;	// hold if timer not done
			else 						next = S3; 	 // advance otherwise
	S3 :	if (~T2DONE) 				next = S3;	// hold if timer not done
			else 						next = S4;  	// advance otherwise
	S4 :	if (~T1DONE) 				next = S4;	// hold if timer not done
			else 						next = S0;	// finish when done
	endcase
end
					//Moore stle output FSM -- always reset clr, cause that a synchronously sets another state with heigherarchy.
always_comb begin			//reset variables as they are used and moved on...
	unique case (present)
	S0 :							{CLR, TOKEN} = 				2'b00; // clear token for next
	S1 :	if (START)				{CLR, TOKEN, START} = 			3'b000;	
			else if (TOKEN && ~START)	{TOKEN, T1DONE, SPRAY, CLRT2, CLR} = 	5'b00000; // reset STUFF
	S2 :	if (T1DONE)				{T2DONE, SOAP, CLRT1,CLR} = 		4'b0000;
	S3 :	if (TDONE)				{SPRAY, T1DONE, CLR} = 			3'b000; 
	S4 :						CLR = 					'0;
	endcase
end
endmodule carwash_fam