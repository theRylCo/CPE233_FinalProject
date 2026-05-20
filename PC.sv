`timescale 1ns/1ps

module pcm (
    input  logic        PCM_RST,
    input  logic        PCM_WE,
    input  logic        PCM_CLK,
    input  logic [1:0]  PCM_SEL,
    input  logic [31:0] PCM_JAL,
    input  logic [31:0] PCM_JALR,
    input  logic [31:0] PCM_BRANCH,

    output logic [31:0] PCM_PLUS4,
    output logic [31:0] PCM_COUNT
);

    logic [31:0] PC_DIN;
    logic [31:0] PCMUX_OUT;

    assign PC_DIN    = PCMUX_OUT;
    assign PCM_PLUS4 = PCM_COUNT + 32'd4;

    always_ff @(posedge PCM_CLK) begin
        if (PCM_RST)
            PCM_COUNT <= 32'h00000000;
        else if (PCM_WE)
            PCM_COUNT <= PC_DIN;
    end

    always_comb begin
        case (PCM_SEL)
            2'd0:    PCMUX_OUT = PCM_PLUS4;
            2'd1:    PCMUX_OUT = PCM_JALR;
            2'd2:    PCMUX_OUT = PCM_BRANCH;
            2'd3:    PCMUX_OUT = PCM_JAL;
            default: PCMUX_OUT = 32'h00000000;
        endcase
    end

endmodule