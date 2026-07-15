module U3_1_coopt
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [9:0]     wire_o_3,
    output         [11:0]     wire_o_11,
    output         [14:0]     wire_o_69
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_5;
    wire    [9:0]    wire_2_3;
    wire    [11:0]    wire_2_11;
    wire    [14:0]    wire_2_69;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:2]    reg_1_5;
    reg     [9:0]    reg_2_3;
    reg     [11:3]    reg_2_11;
    reg     [14:1]    reg_2_69;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_2_3 = (reg_1_1<<1) + reg_1_1;
    assign wire_2_11 = (reg_1_1<<4) - {reg_1_5, reg_1_1[1], reg_1_1[0]};
    assign wire_2_69 = (reg_1_1<<6) + {reg_1_5, reg_1_1[1], reg_1_1[0]};

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1[7:0];
        reg_1_5 <= wire_1_5[10:2];
        reg_2_3 <= wire_2_3[9:0];
        reg_2_11 <= wire_2_11[11:3];
        reg_2_69 <= wire_2_69[14:1];
    end

    // ============ Outputs ============
    assign wire_o_3 = reg_2_3;
    assign wire_o_11 = {reg_2_11, reg_2_3[2], reg_2_3[1], reg_2_3[0]};
    assign wire_o_69 = {reg_2_69, reg_2_3[0]};

endmodule
