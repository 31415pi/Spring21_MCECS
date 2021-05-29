// stimulus.sv - Test bench for Generic N-Bits Adder design module
//
// Author:  Rishitosh Sawant (risawant@pdx.edu)
// Modified by Roy Kravitz (roy.kravitz@pdx.edu)
//
// This module is the stimulus generator for the 4 and 8 bit Carry Lookahead Adders
// that is part of the ECE 351 Homework #1 release
////////////////////////////////////////////////////////////////////
module stimulus
#(
	parameter nBITS = 4,        // number of bits in adder
	parameter DELAY = 10        // delay between stimulus changes
)
(
    output logic [nBITS - 1 : 0]    ain, bin,   // A and B inputs to the DUT
    output logic                    cin,        // carry in to the DUT
    
    input logic  [nBITS - 1 : 0]    sum,        // sum from the DUT (to check)        
	input logic                     cout        // carry out from the DUT
);
	timeunit 1ns/1ns;
    
	// test variables
	logic [nBITS : 0] exp_value;
	logic [nBITS : 0] act_value;
	int i, j, test_count;
	int errors;

	initial begin: test_vector_generator
        errors       = 0;
        test_count  = 0;
        cin 	    = 0;
        
		repeat(2) begin: apply_all_test_cases  
			for(i = 0; i < (1 << nBITS); i++) begin: generate_ain
                ain = i;
                for(j = 0; j < (1 << nBITS); j++) begin: generate_bin
                    test_count++;
                    bin = j;
					#DELAY;
					exp_value = ain + bin + cin;
					act_value = {cout, sum};
                    if({cout, sum} !== exp_value) begin: result_check
                        $write  ($time,,"MISMATCH: Inputs: ain = %d, bin = %d, cin = %b ",  ain, bin, cin);
                        $write  (  "\tActual Outputs: sum = %d, cout = %b",
							act_value[nBITS-1:0], act_value[nBITS]);
                        $display(  "\tExpected Outputs: sum = %d, cout = %d",
							exp_value[nBITS-1:0], exp_value[nBITS]); 
                        errors++;
                    end: result_check
                end: generate_bin 
			end: generate_ain
			cin = ~cin;
		end: apply_all_test_cases

        // report results
		if(errors == 0)
			$display("***Congratulations, No errors found after %d tests***", test_count);
		else
			$display("***Sorry, %d errors were found in your code ***", errors);
	end: test_vector_generator

endmodule: stimulus