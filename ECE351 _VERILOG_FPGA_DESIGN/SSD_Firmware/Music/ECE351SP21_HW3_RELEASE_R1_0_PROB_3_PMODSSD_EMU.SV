
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
	(input logic clk, reset,		//define our ports.
	input logic[4:0] digit1, digit0,
	output logic SSD_AG, SSD_AF, SSD_AE, SSD_AD, SSD_AC,SSD_AB, SSD_AA, 
	logic SSD_C	);
 
	dig_atttor 
		#(	.clk(clk),
			.reset(reset),
			.tick_60Hz(SSD_C)	);
 
	assign SSD_C <= tick_60Hz;
	
	
	function in antoher file --
	{7 segments} = charactercodes(digit1),
	
 always_latch begin
	if (!DISP1_CAT1) <<< ssd_c
		DISP1_AA = anodes_in; << digit1 and digid0
end

always_latch begin
	if (!DISP1_CAT2)
		DISP1_AB = anodes_in;
end


 {SSD_AA, SSD_AB, SSD_AC, SSD_AD,
        SSD_AE, SSD_AF, SSD_AG} = charactercodes(digit1);
{SSD_AA, SSD_AB, SSD_AC, SSD_AD,
        SSD_AE, SSD_AF, SSD_AG} = charactercodes(digit0);





import "DPI-C" function string getenv(input string env_name);

module top;
  initial begin
    $write("env = %s\n", {getenv("HOME"), "/FileName"});
  end
endmodule