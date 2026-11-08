module HP15_baseline
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
    output         [11:0]     wire_o_9,
    output         [11:0]     wire_o_11,
    output         [11:0]     wire_o_13,
    output         [11:0]     wire_o_15,
    output         [12:0]     wire_o_17,
    output         [12:0]     wire_o_19,
    output         [12:0]     wire_o_21,
    output         [12:0]     wire_o_23,
    output         [16:0]     wire_o_507
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [9:0]    wire_1_3;
    wire    [10:0]    wire_1_5;
    wire    [7:0]    wire_2_1;
    wire    [9:0]    wire_2_3;
    wire    [10:0]    wire_2_5;
    wire    [10:0]    wire_2_7;
    wire    [11:0]    wire_2_9;
    wire    [11:0]    wire_2_11;
    wire    [11:0]    wire_2_13;
    wire    [11:0]    wire_2_15;
    wire    [12:0]    wire_2_17;
    wire    [12:0]    wire_2_19;
    wire    [12:0]    wire_2_21;
    wire    [12:0]    wire_2_23;
    wire    [16:0]    wire_2_507;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [9:0]    reg_1_3;
    reg     [10:0]    reg_1_5;
    reg     [7:0]    reg_2_1;
    reg     [9:0]    reg_2_3;
    reg     [10:0]    reg_2_5;
    reg     [10:0]    reg_2_7;
    reg     [11:0]    reg_2_9;
    reg     [11:0]    reg_2_11;
    reg     [11:0]    reg_2_13;
    reg     [11:0]    reg_2_15;
    reg     [12:0]    reg_2_17;
    reg     [12:0]    reg_2_19;
    reg     [12:0]    reg_2_21;
    reg     [12:0]    reg_2_23;
    reg     [16:0]    reg_2_507;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_3 = (x_in<<1) + x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_2_1 = reg_1_1;
    assign wire_2_3 = reg_1_3;
    assign wire_2_5 = reg_1_5;
    assign wire_2_7 = (reg_1_1<<2) + reg_1_3;
    assign wire_2_9 = (reg_1_1<<3) + reg_1_1;
    assign wire_2_11 = (reg_1_1<<3) + reg_1_3;
    assign wire_2_13 = (reg_1_1<<3) + reg_1_5;
    assign wire_2_15 = (reg_1_1<<4) - reg_1_1;
    assign wire_2_17 = (reg_1_1<<4) + reg_1_1;
    assign wire_2_19 = (reg_1_1<<4) + reg_1_3;
    assign wire_2_21 = (reg_1_1<<4) + reg_1_5;
    assign wire_2_23 = (reg_1_3<<3) - reg_1_1;
    assign wire_2_507 = (reg_1_1<<9) - reg_1_5;

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1;
        reg_1_3 <= wire_1_3;
        reg_1_5 <= wire_1_5;
        reg_2_1 <= wire_2_1;
        reg_2_3 <= wire_2_3;
        reg_2_5 <= wire_2_5;
        reg_2_7 <= wire_2_7;
        reg_2_9 <= wire_2_9;
        reg_2_11 <= wire_2_11;
        reg_2_13 <= wire_2_13;
        reg_2_15 <= wire_2_15;
        reg_2_17 <= wire_2_17;
        reg_2_19 <= wire_2_19;
        reg_2_21 <= wire_2_21;
        reg_2_23 <= wire_2_23;
        reg_2_507 <= wire_2_507;
    end

    // ============ Outputs ============
    assign wire_o_1 = reg_2_1;
    assign wire_o_3 = reg_2_3;
    assign wire_o_5 = reg_2_5;
    assign wire_o_7 = reg_2_7;
    assign wire_o_9 = reg_2_9;
    assign wire_o_11 = reg_2_11;
    assign wire_o_13 = reg_2_13;
    assign wire_o_15 = reg_2_15;
    assign wire_o_17 = reg_2_17;
    assign wire_o_19 = reg_2_19;
    assign wire_o_21 = reg_2_21;
    assign wire_o_23 = reg_2_23;
    assign wire_o_507 = reg_2_507;

endmodule
