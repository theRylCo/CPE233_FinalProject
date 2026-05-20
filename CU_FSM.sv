`timescale 1ns/1ps

module CU_FSM(
input logic CU_CLK,
input logic CU_RST,
input logic CU_INTR,
input logic [6:0] CU_OPCODE,

output logic CU_PC_WRITE,
output logic CU_REG_WRITE,
output logic CU_MEM_WE2,
output logic CU_MEM_RDEN1,
output logic CU_MEM_RDEN2,
output logic CU_RESET
);

// FSM states
typedef enum logic [1:0]{
INIT      = 2'd0,
FETCH     = 2'd1,
EXEC      = 2'd2,
WRITEBACK = 2'd3
} state_t;

state_t state,next_state;

// opcodes
localparam [6:0] OP_RTYPE  = 7'b0110011;
localparam [6:0] OP_ITYPE  = 7'b0010011;
localparam [6:0] OP_LOAD   = 7'b0000011;
localparam [6:0] OP_STORE  = 7'b0100011;
localparam [6:0] OP_BRANCH = 7'b1100011;
localparam [6:0] OP_JALR   = 7'b1100111;
localparam [6:0] OP_JAL    = 7'b1101111;
localparam [6:0] OP_LUI    = 7'b0110111;

// state register
always_ff @(posedge CU_CLK) begin
    if(CU_RST)
        state <= INIT;
    else
        state <= next_state;
end

// next state logic
always_comb begin
    case(state)

        INIT:
            next_state = FETCH;

        FETCH:
            next_state = EXEC;

        // loads need extra cycle
        EXEC:
            next_state = (CU_OPCODE == OP_LOAD) ? WRITEBACK : FETCH;

        WRITEBACK:
            next_state = FETCH;

        default:
            next_state = INIT;

    endcase
end

// output logic
always_comb begin

    // defaults
    CU_PC_WRITE  = 1'b0;
    CU_REG_WRITE = 1'b0;
    CU_MEM_WE2   = 1'b0;
    CU_MEM_RDEN1 = 1'b0;
    CU_MEM_RDEN2 = 1'b0;
    CU_RESET     = 1'b0;

    case(state)

        // reset state
        INIT: begin
            CU_RESET = 1'b1;
        end

        // fetch instruction
        FETCH: begin
            CU_MEM_RDEN1 = 1'b1;
        end

        // execute instruction
        EXEC: begin

            // loads hold PC
            if(CU_OPCODE == OP_LOAD) begin
                CU_MEM_RDEN2 = 1'b1;
                CU_PC_WRITE  = 1'b0;
            end

            // normal instructions
            else begin
                CU_PC_WRITE = 1'b1;
            end

            // store instructions
            if(CU_OPCODE == OP_STORE)
                CU_MEM_WE2 = 1'b1;

            // instructions that write registers
            if((CU_OPCODE == OP_RTYPE) ||
               (CU_OPCODE == OP_ITYPE) ||
               (CU_OPCODE == OP_JALR)  ||
               (CU_OPCODE == OP_JAL)   ||
               (CU_OPCODE == OP_LUI))
                CU_REG_WRITE = 1'b1;
        end

        // load writeback
        WRITEBACK: begin
            CU_PC_WRITE  = 1'b1;
            CU_REG_WRITE = 1'b1;
        end

    endcase
end

endmodule