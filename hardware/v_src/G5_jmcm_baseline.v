module G5_jmcm_baseline
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [7:0]     wire_o_1,
    output         [12:0]     wire_o_23,
    output         [16:0]     wire_o_343,
    output         [18:0]     wire_o_1267
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_5;
    wire    [7:0]    wire_2_1;
    wire    [12:0]    wire_2_19;
    wire    [13:0]    wire_2_39;
    wire    [7:0]    wire_3_1;
    wire    [12:0]    wire_3_23;
    wire    [16:0]    wire_3_343;
    wire    [18:0]    wire_3_1267;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:0]    reg_1_5;
    reg     [7:0]    reg_2_1;
    reg     [12:0]    reg_2_19;
    reg     [13:0]    reg_2_39;
    reg     [7:0]    reg_3_1;
    reg     [12:0]    reg_3_23;
    reg     [16:0]    reg_3_343;
    reg     [18:0]    reg_3_1267;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_2_1 = reg_1_1;
    assign wire_2_19 = (reg_1_5<<2) - reg_1_1;
    assign wire_2_39 = (reg_1_5<<3) - reg_1_1;
    assign wire_3_1 = reg_2_1;
    assign wire_3_23 = (reg_2_1<<2) + reg_2_19;
    assign wire_3_343 = (reg_2_19<<4) + reg_2_39;
    assign wire_3_1267 = (reg_2_39<<5) + reg_2_19;

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1;
        reg_1_5 <= wire_1_5;
        reg_2_1 <= wire_2_1;
        reg_2_19 <= wire_2_19;
        reg_2_39 <= wire_2_39;
        reg_3_1 <= wire_3_1;
        reg_3_23 <= wire_3_23;
        reg_3_343 <= wire_3_343;
        reg_3_1267 <= wire_3_1267;
    end

    // ============ Outputs ============
    assign wire_o_1 = reg_3_1;
    assign wire_o_23 = reg_3_23;
    assign wire_o_343 = reg_3_343;
    assign wire_o_1267 = reg_3_1267;

endmodule
