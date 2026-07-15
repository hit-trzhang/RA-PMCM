module LP5_coopt
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [11:0]     wire_o_11,
    output         [13:0]     wire_o_33,
    output         [13:0]     wire_o_35,
    output         [13:0]     wire_o_53,
    output         [14:0]     wire_o_103
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [9:0]    wire_1_3;
    wire    [10:0]    wire_1_7;
    wire    [11:0]    wire_2_11;
    wire    [13:0]    wire_2_33;
    wire    [13:0]    wire_2_35;
    wire    [13:0]    wire_2_53;
    wire    [14:0]    wire_2_103;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [9:1]    reg_1_3;
    reg     [10:2]    reg_1_7;
    reg     [11:0]    reg_2_11;
    reg     [13:1]    reg_2_33;
    reg     [13:3]    reg_2_35;
    reg     [13:2]    reg_2_53;
    reg     [14:2]    reg_2_103;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_3 = (x_in<<1) + x_in;
    assign wire_1_7 = (x_in<<3) - x_in;
    assign wire_2_11 = (reg_1_1<<3) + {reg_1_3, reg_1_1[0]};
    assign wire_2_33 = (reg_1_1<<5) + reg_1_1;
    assign wire_2_35 = (reg_1_1<<5) + {reg_1_3, reg_1_1[0]};
    assign wire_2_53 = ({reg_1_7, reg_1_3[1], reg_1_1[0]}<<3) - {reg_1_3, reg_1_1[0]};
    assign wire_2_103 = ({reg_1_3, reg_1_1[0]}<<5) + {reg_1_7, reg_1_3[1], reg_1_1[0]};

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1[7:0];
        reg_1_3 <= wire_1_3[9:1];
        reg_1_7 <= wire_1_7[10:2];
        reg_2_11 <= wire_2_11[11:0];
        reg_2_33 <= wire_2_33[13:1];
        reg_2_35 <= wire_2_35[13:3];
        reg_2_53 <= wire_2_53[13:2];
        reg_2_103 <= wire_2_103[14:2];
    end

    // ============ Outputs ============
    assign wire_o_11 = reg_2_11;
    assign wire_o_33 = {reg_2_33, reg_2_11[0]};
    assign wire_o_35 = {reg_2_35, reg_2_11[2], reg_2_11[1], reg_2_11[0]};
    assign wire_o_53 = {reg_2_53, reg_2_33[1], reg_2_11[0]};
    assign wire_o_103 = {reg_2_103, reg_2_11[1], reg_2_11[0]};

endmodule
