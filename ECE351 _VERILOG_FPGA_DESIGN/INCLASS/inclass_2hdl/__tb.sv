/////////////////////////////////////////////
// tb.sv - testbench for ECE 351 exercise #2
//
// Author:  Roy Kravitz (roy.kravitz@pdx.edu)
//
/////////////////////////////////////////////
module tb;
import definitions_pkg::*;

localparam UNIQUE_CASE = "TRUE";
localparam VERBOSE = "TRUE";
localparam BITS = 16;
localparam NUM_TESTS = 100;
  
test_selector_t TEST_CASE;

logic [BITS-1:0]       SW;
logic [BITS-1:0]       LED;
int                    TEST_NUMBER, ERROR_COUNT;
  
// instantiations
stimulus_generator
#(
    .BITS(BITS),
    .UNIQUE_CASE(UNIQUE_CASE),
    .VERBOSE(VERBOSE),
    .NUM_TESTS(NUM_TESTS)
) GEN
(
   .sw(SW),
   .test_case(TEST_CASE),
   .test_number(TEST_NUMBER),
   .error_cnt(ERROR_COUNT)
);

top
#(
    .BITS(BITS) 
 ) DUT
(
    .ALU_FUNC(TEST_CASE),
    .SW(SW),
    .LED(LED)
);

check_results
#(
    .BITS(BITS),
    .VERBOSE(VERBOSE)
) CHECK
(
    .SW(SW),
    .LED(LED),
    .test_case(TEST_CASE),
    .test_number(TEST_NUMBER),
    .error_cnt(ERROR_COUNT)
);

endmodule: tb
