module G3_coopt
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [9:0]     wire_o_3,
    output         [12:0]     wire_o_21,
    output         [15:0]     wire_o_159
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_5;
    wire    [9:0]    wire_2_3;
    wire    [12:0]    wire_2_21;
    wire    [15:0]    wire_2_159;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:2]    reg_1_5;
    reg     [9:0]    reg_2_3;
    reg     [12:1]    reg_2_21;
    reg     [15:2]    reg_2_159;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_2_3 = (reg_1_1<<1) + reg_1_1;
    assign wire_2_21 = (reg_1_1<<4) + {reg_1_5, reg_1_1[1], reg_1_1[0]};
    assign wire_2_159 = ({reg_1_5, reg_1_1[1], reg_1_1[0]}<<5) - reg_1_1;

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1[7:0];
        reg_1_5 <= wire_1_5[10:2];
        reg_2_3 <= wire_2_3[9:0];
        reg_2_21 <= wire_2_21[12:1];
        reg_2_159 <= wire_2_159[15:2];
    end

    // ============ Outputs ============
    assign wire_o_3 = reg_2_3;
    assign wire_o_21 = {reg_2_21, reg_2_3[0]};
    assign wire_o_159 = {reg_2_159, reg_2_3[1], reg_2_3[0]};

endmodule
