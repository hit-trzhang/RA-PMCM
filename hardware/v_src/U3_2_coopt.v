module U3_2_coopt
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [13:0]     wire_o_43,
    output         [15:0]     wire_o_171,
    output         [18:0]     wire_o_1109
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_5;
    wire    [7:0]    wire_2_1;
    wire    [14:0]    wire_2_85;
    wire    [13:0]    wire_3_43;
    wire    [15:0]    wire_3_171;
    wire    [18:0]    wire_3_1109;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:2]    reg_1_5;
    reg     [7:0]    reg_2_1;
    reg     [14:2]    reg_2_85;
    reg     [13:0]    reg_3_43;
    reg     [15:7]    reg_3_171;
    reg     [18:1]    reg_3_1109;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_2_1 = reg_1_1;
    assign wire_2_85 = ({reg_1_5, reg_1_1[1], reg_1_1[0]}<<4) + {reg_1_5, reg_1_1[1], reg_1_1[0]};
    assign wire_3_43 = (reg_2_1<<7) - {reg_2_85, reg_2_1[1], reg_2_1[0]};
    assign wire_3_171 = (reg_2_1<<8) - {reg_2_85, reg_2_1[1], reg_2_1[0]};
    assign wire_3_1109 = (reg_2_1<<10) + {reg_2_85, reg_2_1[1], reg_2_1[0]};

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1[7:0];
        reg_1_5 <= wire_1_5[10:2];
        reg_2_1 <= wire_2_1[7:0];
        reg_2_85 <= wire_2_85[14:2];
        reg_3_43 <= wire_3_43[13:0];
        reg_3_171 <= wire_3_171[15:7];
        reg_3_1109 <= wire_3_1109[18:1];
    end

    // ============ Outputs ============
    assign wire_o_43 = reg_3_43;
    assign wire_o_171 = {reg_3_171, reg_3_43[6], reg_3_43[5], reg_3_43[4], reg_3_43[3], reg_3_43[2], reg_3_43[1], reg_3_43[0]};
    assign wire_o_1109 = {reg_3_1109, reg_3_43[0]};

endmodule
