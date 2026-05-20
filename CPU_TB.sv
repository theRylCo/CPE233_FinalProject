`timescale 1ns/1ps

module CPU_TB;

logic CLK;
logic RST;
logic INTR;
logic [31:0] IOBUS_IN;
logic [31:0] IOBUS_OUT;
logic [31:0] IOBUS_ADDR;
logic IOBUS_WR;

CPU DUT(
.CLK(CLK),
.RST(RST),
.INTR(INTR),
.IOBUS_IN(IOBUS_IN),
.IOBUS_OUT(IOBUS_OUT),
.IOBUS_ADDR(IOBUS_ADDR),
.IOBUS_WR(IOBUS_WR)
);

// clock
initial begin
    CLK = 1'b0;
    forever #5 CLK = ~CLK;
end

// test sequence
initial begin
    RST = 1'b1;
    INTR = 1'b0;
    IOBUS_IN = 32'h00000000;

    #20;
    RST = 1'b0;

    // let CPU run
    #500;

    $finish;
end

endmodule