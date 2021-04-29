/////////////////////////////////////////////
// definitions_pkg.sv - Package containing the definitions for ECE 351 exercise #2
//
// Author:  Roy Kravitz (roy.kravitz@pdx.edu)
//
/////////////////////////////////////////////
package definitions_pkg;

timeunit 1ns/1ns;

// options
typedef enum {LEADING_ONES, NUM_ONES, ADD, SUB, MULT} test_selector_t;
typedef enum {UNIQUE_CASE, CASE, CASE_INSIDE, UP_FOR, DOWN_FOR} lo_options_t ;
typedef enum {ALU_ADD, ALU_SUB} add_sub_options_t;

// These definitions may be used for Nexys A7 version which has a specific arrangement
// of switches and buttons

// button masks
`define BTNC 5'b10000;
`define BTNU 5'b01000;
`define BTND 5'b00100;
`define BTNL 5'b00010;
`define BTNR 5'b00001;

// io register struct
typedef struct packed  {
    logic [7:0] hi_byte;
    logic [7:0] lo_byte;
} ioreg_t;

typedef union packed  {
    ioreg_t ioreg_bytes;
    logic [15:0] ioreg;
} ioreg_union_t;

endpackage: definitions_pkg







