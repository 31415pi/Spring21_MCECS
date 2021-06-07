// tb_CLA4Bit.sv - Test bench for 4-bit carry lookahead adder
//
// Author:  Rishitosh Sawant (risawant@pdx.edu)
// Modified by Roy Kravitz (roy.kravitz@pdx.edu)
//
// This module the top level testbench for the 8-bit carry lookahead adders
// in ECE 351 Homework #1
////////////////////////////////////////////////////////////////////
module tb_CLA8BIT;

// internal variables
logic [7:0] ain, bin;
logic       cin;
logic [7:0] sum;
logic       cout;

// instantiate the stimulus generator and adder
stimulus #(.nBITS(8)) TESTGEN (.*);
CLA8Bit  DUT (.*, .cin(cin));

endmodule: tb_CLA8BIT