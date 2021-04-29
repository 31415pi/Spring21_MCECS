/////////////////////////////////////////////
// top.sv - top level (DUT) for ECE 351 exercise #2
//
// Author:  <Your name> (<your email address>)
//
// Instantiates the modules in the DUT (an ALU of sorts)
// and multiplexes the LED output based on the ALU function
/////////////////////////////////////////////
module top
import definitions_pkg::*;
#(
    parameter BITS = 16   
 )
(
    input test_selector_t       ALU_FUNC,   // Used to select which set of LEDs to return
    input logic [BITS-1:0]      SW,         // slide switches
    output logic [BITS-1:0]     LED         // LEDs
);

// internal variables for the LED values...remember all the hardware is running concurrently
logic [$clog2(BITS):0] LO_LED;      // leading ones LEDs
logic [$clog2(BITS):0] NO_LED;      // number of ones LEDs
logic [BITS-1:0]       ADD_LED;     // Adder LEDs
logic [BITS-1:0]       SUB_LED;     // Subtractor LEDS
logic [BITS-1:0]       MULT_LED;    // Multiplication LEDS

// instantiate the ALU functions
// You need 1 leading_ones, 1 num_ones, 1 mult, and 2 add_sub - one configured as an
// adder and the second configured as a subtractor

// ADD YOUR CODE HERE

// LED multiplexer - selects one of the LED output from the the ALU functions
// based on  ALU_FUNC.  Use an always_comb block and either an if..else treee or a 
// case statement.  You can handle the case of an invalid ALU_FUNC by setting LED to 'x

// ADD YOUR CODE HERE

endmodule: top