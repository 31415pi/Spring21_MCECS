/////////////////////////////////////////////
// check_results.sv - checker ECE 351 exercise #2
//
// Author:  Roy Kravitz (roy.kravitz@pdx.edu)
//
// checks the results of the test cases
/////////////////////////////////////////////
module check_results
import definitions_pkg::*;
#(
    parameter BITS = 16,
    parameter VERBOSE = "FALSE"
)
(
    input logic [BITS-1:0]  SW,             // switches are used as inputs to ALU functions
    input logic [BITS-1:0]  LED,            // LEDs are used to display the results
    input test_selector_t   test_case,      // test cases are mapped to simulated button presses
    
    // information variables
    input int               test_number,    // test number (incremented by stimulus block)
    output int              error_cnt       // error count                       
);

// internal variables
int sw_pos;
logic signed [BITS-1:0] sw_alu;

initial begin
    error_cnt = 0;
end

// perform a check every time a new test is initiated
always @(test_number) begin: check_results
    #50;   // wait for the ALU results to settle
    sw_pos  = '0;
    if (test_case == LEADING_ONES) begin
        if (VERBOSE == "TRUE")
            $display("TEST CASE(%4d): %s\tExpected: %b, Got: %b_%b\n",
                test_number,
                test_case,
                lo_func(SW),
                LED[$high(LED):($size(LED)/2)],
                LED[($size(LED)/2 - 1):$low(LED)]);        
        if (lo_func(SW) != LED[$clog2(BITS):0]) begin
            $display("FAIL: LED != leading 1's position\tExpected: %b, Got: %b", lo_func(SW), LED[$clog2(BITS):0]);
            error_cnt++;
            if (VERBOSE == "FALSE")
                $stop;
        end
    end
    else if (test_case == NUM_ONES) begin
        if (VERBOSE == "TRUE")
            $display("TEST CASE(%4d): %s\tExpected: %b, Got: %b_%b\n", test_number, test_case, no_func(SW), LED[15:8], LED[7:0]);
        if (no_func(SW) != LED) begin
            $display("FAIL: LED != number of ones represented by SW\tExpected: %b, Got: %b", no_func(SW), LED[$clog2(BITS):0]);
            error_cnt++;
            if (VERBOSE == "FALSE")
                $stop;
        end
    end
    else if (test_case == ADD) begin
 //       sw_alu = signed'(SW[15:8]) + signed'(SW[7:0]);
        sw_alu = signed'(SW[$high(SW):($size(SW)/2)]) + signed'(SW[($size(SW)/2 - 1):$low(SW)]);
        if (VERBOSE == "TRUE")
            $display("TEST CASE(%4d): %s\tExpected: %b, Got: %b_%b\n", test_number, test_case, sw_alu, LED[15:8], LED[7:0]);
        if (sw_alu != LED) begin
            $display("FAIL: LED != sum of SW[15:8] + SW[7:0]");
            error_cnt++;
            if (VERBOSE == "FALSE")
                $stop;
        end
    end
    else if (test_case == SUB) begin
//        sw_alu = signed'(SW[15:8]) - signed'(SW[7:0]);
        sw_alu = signed'(SW[$high(SW):($size(SW)/2)]) - signed'(SW[($size(SW)/2 - 1):$low(SW)]);
        if (VERBOSE == "TRUE")
            $display("TEST CASE(%4d): %s\tExpected: %b, Got: %b_%b\n", test_number, test_case, sw_alu, LED[15:8], LED[7:0]);
        if (sw_alu != LED) begin
            $display("FAIL: LED != difference of SW[15:8] - SW[7:0]");
            error_cnt++;
            if (VERBOSE == "FALSE")
                $stop;
        end
    end
    else if (test_case == MULT) begin
//        sw_alu = signed'(SW[15:8]) * signed'(SW[7:0]);
        sw_alu = signed'(SW[$high(SW):($size(SW)/2)]) * signed'(SW[($size(SW)/2 - 1):$low(SW)]);
        if (VERBOSE == "TRUE")
            $display("TEST CASE(%4d): %s\tExpected: %b, Got: %b_%b\n", test_number, test_case, sw_alu, LED[15:8], LED[7:0]);
        if (sw_alu != LED) begin
            $display("FAIL: LED != product of SW[15:8] * SW[7:0]");
            error_cnt++;
            if (VERBOSE == "FALSE")
                $stop;
        end
    end
end: check_results


// helper functions
function [$clog2(BITS):0] lo_func(input [BITS-1:0] SW);
    lo_func = '0;
    for (int i = $low(SW); i <= $high(SW); i++) begin
        if (SW[i]) begin
            lo_func  = i+1;
        end
    end
endfunction : lo_func

function [$clog2(BITS):0] no_func(input [BITS-1:0] SW);
    no_func = '0;
    for (int i = $low(SW); i <= $high(SW); i++) begin
        no_func  += SW[i];
    end
endfunction : no_func

endmodule: check_results