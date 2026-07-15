module HP5_coopt
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [7:0]     wire_o_1,
    output         [9:0]     wire_o_3,
    output         [10:0]     wire_o_5,
    output         [10:0]     wire_o_7,
    output         [14:0]     wire_o_121
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_7;
    wire    [7:0]    wire_2_1;
    wire    [9:0]    wire_2_3;
    wire    [10:0]    wire_2_5;
    wire    [10:0]    wire_2_7;
    wire    [14:0]    wire_2_121;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:1]    reg_1_7;
    reg     [7:0]    reg_2_1;
    reg     [9:1]    reg_2_3;
    reg     [10:2]    reg_2_5;
    reg     [10:2]    reg_2_7;
    reg     [14:3]    reg_2_121;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_7 = (x_in<<3) - x_in;
    assign wire_2_1 = reg_1_1;
    assign wire_2_3 = (reg_1_1<<1) + reg_1_1;
    assign wire_2_5 = (reg_1_1<<2) + reg_1_1;
    assign wire_2_7 = {reg_1_7, reg_1_1[0]};
    assign wire_2_121 = (reg_1_1<<7) - {reg_1_7, reg_1_1[0]};

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1[7:0];
        reg_1_7 <= wire_1_7[10:1];
        reg_2_1 <= wire_2_1[7:0];
        reg_2_3 <= wire_2_3[9:1];
        reg_2_5 <= wire_2_5[10:2];
        reg_2_7 <= wire_2_7[10:2];
        reg_2_121 <= wire_2_121[14:3];
    end

    // ============ Outputs ============
    assign wire_o_1 = reg_2_1;
    assign wire_o_3 = {reg_2_3, reg_2_1[0]};
    assign wire_o_5 = {reg_2_5, reg_2_1[1], reg_2_1[0]};
    assign wire_o_7 = {reg_2_7, reg_2_3[1], reg_2_1[0]};
    assign wire_o_121 = {reg_2_121, reg_2_1[2], reg_2_1[1], reg_2_1[0]};

endmodule
