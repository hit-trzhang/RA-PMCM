module LP9_baseline
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [7:0]     wire_o_1,
    output         [10:0]     wire_o_5,
    output         [10:0]     wire_o_7,
    output         [12:0]     wire_o_25,
    output         [12:0]     wire_o_31,
    output         [13:0]     wire_o_63,
    output         [14:0]     wire_o_65,
    output         [14:0]     wire_o_67,
    output         [14:0]     wire_o_73,
    output         [14:0]     wire_o_97,
    output         [14:0]     wire_o_117,
    output         [15:0]     wire_o_165,
    output         [16:0]     wire_o_303
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_5;
    wire    [10:0]    wire_1_7;
    wire    [12:0]    wire_1_17;
    wire    [7:0]    wire_2_1;
    wire    [10:0]    wire_2_5;
    wire    [10:0]    wire_2_7;
    wire    [12:0]    wire_2_25;
    wire    [12:0]    wire_2_31;
    wire    [13:0]    wire_2_63;
    wire    [14:0]    wire_2_65;
    wire    [14:0]    wire_2_67;
    wire    [14:0]    wire_2_73;
    wire    [14:0]    wire_2_97;
    wire    [14:0]    wire_2_117;
    wire    [15:0]    wire_2_165;
    wire    [16:0]    wire_2_303;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:0]    reg_1_5;
    reg     [10:0]    reg_1_7;
    reg     [12:0]    reg_1_17;
    reg     [7:0]    reg_2_1;
    reg     [10:0]    reg_2_5;
    reg     [10:0]    reg_2_7;
    reg     [12:0]    reg_2_25;
    reg     [12:0]    reg_2_31;
    reg     [13:0]    reg_2_63;
    reg     [14:0]    reg_2_65;
    reg     [14:0]    reg_2_67;
    reg     [14:0]    reg_2_73;
    reg     [14:0]    reg_2_97;
    reg     [14:0]    reg_2_117;
    reg     [15:0]    reg_2_165;
    reg     [16:0]    reg_2_303;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_1_7 = (x_in<<3) - x_in;
    assign wire_1_17 = (x_in<<4) + x_in;
    assign wire_2_1 = reg_1_1;
    assign wire_2_5 = reg_1_5;
    assign wire_2_7 = reg_1_7;
    assign wire_2_25 = (reg_1_1<<5) - reg_1_7;
    assign wire_2_31 = (reg_1_1<<5) - reg_1_1;
    assign wire_2_63 = (reg_1_1<<6) - reg_1_1;
    assign wire_2_65 = (reg_1_1<<6) + reg_1_1;
    assign wire_2_67 = (reg_1_17<<2) - reg_1_1;
    assign wire_2_73 = (reg_1_7<<3) + reg_1_17;
    assign wire_2_97 = (reg_1_5<<4) + reg_1_17;
    assign wire_2_117 = (reg_1_7<<4) + reg_1_5;
    assign wire_2_165 = (reg_1_5<<5) + reg_1_5;
    assign wire_2_303 = (reg_1_5<<6) - reg_1_17;

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1;
        reg_1_5 <= wire_1_5;
        reg_1_7 <= wire_1_7;
        reg_1_17 <= wire_1_17;
        reg_2_1 <= wire_2_1;
        reg_2_5 <= wire_2_5;
        reg_2_7 <= wire_2_7;
        reg_2_25 <= wire_2_25;
        reg_2_31 <= wire_2_31;
        reg_2_63 <= wire_2_63;
        reg_2_65 <= wire_2_65;
        reg_2_67 <= wire_2_67;
        reg_2_73 <= wire_2_73;
        reg_2_97 <= wire_2_97;
        reg_2_117 <= wire_2_117;
        reg_2_165 <= wire_2_165;
        reg_2_303 <= wire_2_303;
    end

    // ============ Outputs ============
    assign wire_o_1 = reg_2_1;
    assign wire_o_5 = reg_2_5;
    assign wire_o_7 = reg_2_7;
    assign wire_o_25 = reg_2_25;
    assign wire_o_31 = reg_2_31;
    assign wire_o_63 = reg_2_63;
    assign wire_o_65 = reg_2_65;
    assign wire_o_67 = reg_2_67;
    assign wire_o_73 = reg_2_73;
    assign wire_o_97 = reg_2_97;
    assign wire_o_117 = reg_2_117;
    assign wire_o_165 = reg_2_165;
    assign wire_o_303 = reg_2_303;

endmodule
