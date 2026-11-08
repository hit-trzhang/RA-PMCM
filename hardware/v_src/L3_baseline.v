module L3_baseline
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [10:0]     wire_o_5,
    output         [12:0]     wire_o_21,
    output         [14:0]     wire_o_107
);


    // ============ Wires ============
    wire    [10:0]    wire_1_5;
    wire    [10:0]    wire_1_7;
    wire    [10:0]    wire_2_5;
    wire    [12:0]    wire_2_21;
    wire    [14:0]    wire_2_107;

    // ============ Registers ============
    reg     [10:0]    reg_1_5;
    reg     [10:0]    reg_1_7;
    reg     [10:0]    reg_2_5;
    reg     [12:0]    reg_2_21;
    reg     [14:0]    reg_2_107;

    // ============ Combinational Logic ============
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_1_7 = (x_in<<3) - x_in;
    assign wire_2_5 = reg_1_5;
    assign wire_2_21 = (reg_1_7<<1) + reg_1_7;
    assign wire_2_107 = (reg_1_7<<4) - reg_1_5;

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_5 <= wire_1_5;
        reg_1_7 <= wire_1_7;
        reg_2_5 <= wire_2_5;
        reg_2_21 <= wire_2_21;
        reg_2_107 <= wire_2_107;
    end

    // ============ Outputs ============
    assign wire_o_5 = reg_2_5;
    assign wire_o_21 = reg_2_21;
    assign wire_o_107 = reg_2_107;

endmodule
