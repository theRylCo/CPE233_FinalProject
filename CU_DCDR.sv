`timescale 1ns/1ps

module CU_DCDR(

input logic [6:0] CU_OPCODE,
input logic [2:0] CU_FUNCT3,
input logic CU_IR30,

input logic CU_BR_EQ,
input logic CU_BR_LT,
input logic CU_BR_LTU,

output logic [3:0] CU_ALU_FUN,
output logic CU_ALU_SRCA,
output logic [1:0] CU_ALU_SRCB,
output logic [1:0] CU_PC_SOURCE,
output logic [1:0] CU_RF_WR_SEL,
output logic [1:0] CU_MEM_SIZE,
output logic CU_MEM_SIGN
);

// opcodes
localparam [6:0] OP_RTYPE  = 7'b0110011;
localparam [6:0] OP_ITYPE  = 7'b0010011;
localparam [6:0] OP_LOAD   = 7'b0000011;
localparam [6:0] OP_STORE  = 7'b0100011;
localparam [6:0] OP_BRANCH = 7'b1100011;
localparam [6:0] OP_JALR   = 7'b1100111;
localparam [6:0] OP_JAL    = 7'b1101111;
localparam [6:0] OP_LUI    = 7'b0110111;

always_comb begin

    // defaults
    CU_ALU_FUN   = 4'b0000;
    CU_ALU_SRCA  = 1'b0;
    CU_ALU_SRCB  = 2'd0;
    CU_PC_SOURCE = 2'd0;
    CU_RF_WR_SEL = 2'd2;
    CU_MEM_SIZE  = 2'd2;
    CU_MEM_SIGN  = 1'b0;

    case(CU_OPCODE)

        // R-type
        OP_RTYPE: begin

            CU_ALU_SRCA  = 1'b0;
            CU_ALU_SRCB  = 2'd0;
            CU_RF_WR_SEL = 2'd2;

            // sub
            if((CU_FUNCT3 == 3'b000) && CU_IR30)
                CU_ALU_FUN = 4'b1000;

            // sra
            else if((CU_FUNCT3 == 3'b101) && CU_IR30)
                CU_ALU_FUN = 4'b1101;

            // normal ops
            else
                CU_ALU_FUN = {1'b0,CU_FUNCT3};
        end

        // I-type
        OP_ITYPE: begin

            CU_ALU_SRCA  = 1'b0;
            CU_ALU_SRCB  = 2'd1;
            CU_RF_WR_SEL = 2'd2;

            // srai
            if((CU_FUNCT3 == 3'b101) && CU_IR30)
                CU_ALU_FUN = 4'b1101;

            else
                CU_ALU_FUN = {1'b0,CU_FUNCT3};
        end

        // loads
        OP_LOAD: begin

            // address = rs1 + imm
            CU_ALU_SRCA  = 1'b0;
            CU_ALU_SRCB  = 2'd1;
            CU_ALU_FUN   = 4'b0000;

            // write memory data back
            CU_RF_WR_SEL = 2'd1;

            case(CU_FUNCT3)

                3'b000: begin
                    CU_MEM_SIZE = 2'd0; // lb
                    CU_MEM_SIGN = 1'b0;
                end

                3'b001: begin
                    CU_MEM_SIZE = 2'd1; // lh
                    CU_MEM_SIGN = 1'b0;
                end

                3'b010: begin
                    CU_MEM_SIZE = 2'd2; // lw
                    CU_MEM_SIGN = 1'b0;
                end

                3'b100: begin
                    CU_MEM_SIZE = 2'd0; // lbu
                    CU_MEM_SIGN = 1'b1;
                end

                3'b101: begin
                    CU_MEM_SIZE = 2'd1; // lhu
                    CU_MEM_SIGN = 1'b1;
                end

            endcase
        end

        // stores
        OP_STORE: begin

            // address = rs1 + imm
            CU_ALU_SRCA = 1'b0;
            CU_ALU_SRCB = 2'd2;
            CU_ALU_FUN  = 4'b0000;

            case(CU_FUNCT3)

                3'b000:
                    CU_MEM_SIZE = 2'd0; // sb

                3'b001:
                    CU_MEM_SIZE = 2'd1; // sh

                3'b010:
                    CU_MEM_SIZE = 2'd2; // sw

            endcase
        end

        // branches
        OP_BRANCH: begin

            case(CU_FUNCT3)

                3'b000:
                    CU_PC_SOURCE = CU_BR_EQ ? 2'd2 : 2'd0; // beq

                3'b001:
                    CU_PC_SOURCE = !CU_BR_EQ ? 2'd2 : 2'd0; // bne

                3'b100:
                    CU_PC_SOURCE = CU_BR_LT ? 2'd2 : 2'd0; // blt

                3'b101:
                    CU_PC_SOURCE = !CU_BR_LT ? 2'd2 : 2'd0; // bge

                3'b110:
                    CU_PC_SOURCE = CU_BR_LTU ? 2'd2 : 2'd0; // bltu

                3'b111:
                    CU_PC_SOURCE = !CU_BR_LTU ? 2'd2 : 2'd0; // bgeu

            endcase
        end

        // jal
        OP_JAL: begin
            CU_PC_SOURCE = 2'd3;
            CU_RF_WR_SEL = 2'd0;
        end

        // jalr
        OP_JALR: begin
            CU_PC_SOURCE = 2'd1;
            CU_RF_WR_SEL = 2'd0;
        end

        // lui
        OP_LUI: begin
            CU_RF_WR_SEL = 2'd3;
        end

    endcase
end

endmodule