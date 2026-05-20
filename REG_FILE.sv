`timescale 1ns / 1ps


module REG_FILE (
    input  logic        RF_CLK,
    input  logic        RF_WE,
    input  logic [4:0]  RF_ADR1,
    input  logic [4:0]  RF_ADR2,
    input  logic [4:0]  RF_WA,
    input  logic [31:0] RF_WD,

    output logic [31:0] RF_RS1,
    output logic [31:0] RF_RS2
);

    logic [31:0] REG_RAM [0:31];

    integer i;

    initial begin
        for(i=0;i<32;i=i+1)
            REG_RAM[i]=32'b0;
    end

    always_ff @(posedge RF_CLK) begin
        if(RF_WE && (RF_WA != 5'd0))
            REG_RAM[RF_WA] <= RF_WD;

        REG_RAM[0] <= 32'b0;
    end

    assign RF_RS1 = (RF_ADR1 == 5'd0) ? 32'b0 : REG_RAM[RF_ADR1];
    assign RF_RS2 = (RF_ADR2 == 5'd0) ? 32'b0 : REG_RAM[RF_ADR2];

endmodule