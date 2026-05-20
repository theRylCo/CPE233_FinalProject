`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/15/2026 04:32:31 PM
// Design Name: 
// Module Name: PC_2
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


`timescale 1ns/1ps
module PC_2 (
    input  logic        clk,
    input  logic        rst,
    input  logic        we,
    input  logic [31:0] pc_din,
    output logic [31:0] pc_count
);

always_ff @(posedge clk) begin
    if (rst)
        pc_count <= 32'h00000000;
    else if (we)
        pc_count <= pc_din;
end

endmodule