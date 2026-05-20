`timescale 1ns / 1ps

module IMM_GEN(
    input  logic [31:0] IR,

    output logic [31:0] U_TYPE,
    output logic [31:0] I_TYPE,
    output logic [31:0] S_TYPE,
    output logic [31:0] B_TYPE,
    output logic [31:0] J_TYPE
);

always_comb begin

    // U-type
    U_TYPE = {IR[31:12],12'b0};

    // I-type
    I_TYPE = {{21{IR[31]}},IR[30:20]};

    // S-type
    S_TYPE = {{21{IR[31]}},IR[30:25],IR[11:7]};

    // B-type
    B_TYPE = {{20{IR[31]}},IR[7],IR[30:25],IR[11:8],1'b0};

    // J-type
    J_TYPE = {{12{IR[31]}},IR[19:12],IR[20],IR[30:21],1'b0};

end

endmodule
