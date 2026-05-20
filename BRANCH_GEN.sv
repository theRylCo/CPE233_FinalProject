`timescale 1ns / 1ps


module BRANCH_GEN (
    input  logic [31:0] PC,
    input  logic [31:0] J_TYPE,
    input  logic [31:0] B_TYPE,
    input  logic [31:0] I_TYPE,
    input  logic [31:0] RS1,

    output logic [31:0] JAL,
    output logic [31:0] BRANCH,
    output logic [31:0] JALR
);

always_comb begin
    JAL    = PC + J_TYPE;
    BRANCH = PC + B_TYPE;
    JALR   = (RS1 + I_TYPE) & 32'hFFFFFFFE;
end

endmodule