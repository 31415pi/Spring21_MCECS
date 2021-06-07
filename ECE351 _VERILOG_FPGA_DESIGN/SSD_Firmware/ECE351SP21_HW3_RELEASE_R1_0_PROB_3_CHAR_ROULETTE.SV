/*  Assignment:				Homework 3
 *  Filename:				ECE351_HW3/FIN/part3/ECE351SP21_HW3_RELEASE_R1_0_PROB_3_CHAR_ROULETTE.SV
 * 	Description:		Function to implement char segment lookup table case statement.
 *  					Portland State University
 *  ECE 362: 				Verilog and FPGA Design
 *  Term: 				Spring 2021
 *  Proffessor: 			Prof. Roy Kravitz
 *  T/A:				Tyler Hull
 *  Grader:				Tiffani Shilts Hartman
 *  CRN: 				61016
 *  Student: 				Mx. Madison Uxia Klementyn
 *  Creation Date: 			23.05.2021
 *  Due Date:				24.05.2021 - 1700 hours
 *  Estimated Completion:  		1 hour prep,
 *  Notable Fact: 			
 *  References 				Sutherland. 
 *  &links:			regex101.com/r/bcv4DD/1   had to run in a few passes after this. https://regex101.com/r/zVsiPb/1
 *		https://www.chipverify.com/systemverilog/systemverilog-package#:~:text=Packages%20provide%20a%20mechanism%20for,as%20the%20top%2Dlevel%20module.
 */
package CHAR_ROULETTE;
	timeunit 1ns/1ns; 	//this package has its own clock so there is no lag on deriving the lookup value

	function logic [6:0] BtS ( input logic [4:0] binaryvalues ) ;
		case(binaryvalues)
			5'b00000 : BtS = 7'b1111110; //0 - 00 []
			5'b00001 : BtS = 7'b0000110; //1 - 01 []
			5'b00010 : BtS = 7'b1101101; //2 - 02 []
			5'b00011 : BtS = 7'b1111001; //3 - 03 []
			5'b00100 : BtS = 7'b0110011; //4 - 04 []
			5'b00101 : BtS = 7'b1011011; //5 - 05 []
			5'b00110 : BtS = 7'b1011111; //6 - 06 []
			5'b00111 : BtS = 7'b1110000; //7 - 07 []
			5'b01000 : BtS = 7'b1111111; //8 - 08 []
			5'b01001 : BtS = 7'b1111011; //9 - 09 []
			5'b01010 : BtS = 7'b1110111; //10 - 0A []
			5'b01011 : BtS = 7'b0011111; //11 - 0B []
			5'b01100 : BtS = 7'b1001110; //12 - 0C []
			5'b01101 : BtS = 7'b0111101; //13 - 0D []
			5'b01110 : BtS = 7'b1001111; //14 - 0E []
			5'b01111 : BtS = 7'b1000111; //15 - 0F []
			5'b10000 : BtS = 7'b1000000; // Segment a; //16 - 10 []
			5'b00001 : BtS = 7'b0100000; // Segment b; //17 - 11 []
			5'b10010 : BtS = 7'b0010000; // Segment c; //18 - 12 []
			5'b10011 : BtS = 7'b0001000; // Segment d; //19 - 13 []
			5'b10100 : BtS = 7'b0000100; // Segment e; //20 - 14 []
			5'b10101 : BtS = 7'b0000010; // Segment f; //21 - 15 []
			5'b10110 : BtS = 7'b0000001; // Segment g; //22 - 16 []
			5'b10111 : BtS = 7'b0000000; // BLANK; //23 - 17 []
			5'b11000 : BtS = 7'b0110111; // Upper case H; //24 - 18 []
			5'b11001 : BtS = 7'b0001110; // Upper case L; //25 - 19 []
			5'b11010 : BtS = 7'b1110111; // Upper case R; //26 - 1A []
			5'b11011 : BtS = 7'b0000110; // Lower case L; //27 - 1B []
			5'b11100 : BtS = 7'b0000101; // Lower case R; //28 - 1C []
			5'b11101 : BtS = 7'b0000000; // BLANK; //29 - 1D []
			5'b11110 : BtS = 7'b0000000; // BLANK; //30 - 1E []
			5'b11111 : BtS = 7'b0000000; // BLANK; //31 - 1F []
			default:   BtS = 7'b1111000; // erroneoous input -- dont care
		endcase
	endfunction
endpackage : CHAR_ROULETTE