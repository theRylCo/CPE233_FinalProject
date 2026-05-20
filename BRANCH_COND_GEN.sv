`timescale 1ns / 1ps
module BRANCH_COND_GEN ( 
    input  logic [31:0] BCG_RS1, 
    input  logic [31:0] BCG_RS2, 
     
    output logic        BCG_BR_EQ, 
    output logic        BCG_BR_LT, 
    output logic        BCG_BR_LTU 
); 
 
always_comb begin 
    BCG_BR_EQ  = (BCG_RS1 == BCG_RS2);
    BCG_BR_LT  = ($signed(BCG_RS1) < $signed(BCG_RS2));
    BCG_BR_LTU = (BCG_RS1 < BCG_RS2);
end 
 
endmodule