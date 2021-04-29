/////////////////////////////////////////////
// stimulus_generator.sv - stimulus generator for ECE 351 exercise #2
//
// Author:  Roy Kravitz (roy.kravitz@pdx.edu)
//
// generates the TEST_CASE for the "ALU"
// will be replaced w/ button presses and switch settings
//  when we put this design on the Nexys A7.
/////////////////////////////////////////////
program stimulus_generator
import definitions_pkg::*;
#(
    parameter BITS = 16,
    parameter UNIQUE_CASE = "FALSE",
    parameter VERBOSE = "FALSE",O
    parameter NUM_TESTS = 100
)
(
    output logic [BITS-1:0] sw,             // switches are used to provide ALU function inputs
    output test_selector_t  test_case,      // test cases are mapped to simulated button presses
    
    // information variables
    output int              test_number,    //test number
    input int               error_cnt       // error count from the checker
);

// internal variables
logic set_zero;    // used as a boolean to ensure a single one is generated if UNIQUE_CASE = "TRUE"
int test_case_num;      // holds the randomly generated test casse

initial begin: gen_test_vectors
    $printtimescale(tb);
    //select a test an execute it
    for (int i = 0; i < NUM_TESTS; i++) begin : generate_test_cases
        test_number = i + 1;
        test_case_num = $urandom_range(0,4);       
        case (test_case_num)
            0: test_case = MULT;
            1: test_case = LEADING_ONES;
            2: test_case = NUM_ONES;
            3: test_case = ADD;
            4: test_case = SUB;
        endcase // case (test_num)

        // set the simulated switches
        sw = $random;
  
        // if UNIQUE_CASE is true we need to only "set" one switch to 1
        if ((UNIQUE_CASE == "TRUE") && (test_case inside {LEADING_ONES, NUM_ONES})) begin : handle_unique_case
            set_zero = '0;
            for (int j = BITS-1; j >= 0; j--) begin
                if (set_zero) begin
                    sw[j] = '0;
                end
                else if (sw[j] && j > 0) begin
                    // if we find a 1 at a position other than in bit 0, set all lower
                    // bits to 0. This ensures we will only have 1 bit at most set.
                    set_zero = '1;
                end
            end
        end : handle_unique_case
        $display("...Setting switches to: %b", sw);
        #50;
    end : generate_test_cases
    
    // wrap up.  simulation will stop w/ a message on the first failure
    sw = '0;
    #100;
    if (error_cnt == 0) begin
        $display("SUCCESS: Exercise #2 test PASSED %5d TESTS!", NUM_TESTS);
    end
    else begin
        $display("FAILURE: Exercise #2 test FAILED %4d FAILURES out of %4d TESTS!", error_cnt, NUM_TESTS); 
    end
    $stop;
end: gen_test_vectors

endprogram : stimulus_generator


    
    
    