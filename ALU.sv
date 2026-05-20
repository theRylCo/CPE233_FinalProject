
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/18/2026 09:15:52 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps

module ALU (
    input  logic [31:0] ALU_A,
    input  logic [31:0] ALU_B,
    input  logic [3:0]  ALU_FUN,

    output logic [31:0] ALU_RESULT
);

always_comb begin
    case(ALU_FUN)

        4'b0000: ALU_RESULT = ALU_A + ALU_B;                         // ADD
        4'b1000: ALU_RESULT = ALU_A - ALU_B;                         // SUB

        4'b0001: ALU_RESULT = ALU_A << ALU_B[4:0];                   // SLL
        4'b0101: ALU_RESULT = ALU_A >> ALU_B[4:0];                   // SRL
        4'b1101: ALU_RESULT = $signed(ALU_A) >>> ALU_B[4:0];         // SRA

        4'b0010: ALU_RESULT = ($signed(ALU_A) < $signed(ALU_B)) 
                               ? 32'd1 : 32'd0;                     // SLT

        4'b0011: ALU_RESULT = (ALU_A < ALU_B) 
                               ? 32'd1 : 32'd0;                     // SLTU

        4'b0100: ALU_RESULT = ALU_A ^ ALU_B;                         // XOR
        4'b0110: ALU_RESULT = ALU_A | ALU_B;                         // OR
        4'b0111: ALU_RESULT = ALU_A & ALU_B;                         // AND

        4'b1001: ALU_RESULT = ALU_B;                                 // LUI / pass B

        default: ALU_RESULT = 32'h00000000;

    endcase
end

endmodule