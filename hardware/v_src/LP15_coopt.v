module LP15_coopt
#(
    parameter DATA_WIDTH = 8
)
(
    input                               clk,
    input          [DATA_WIDTH-1:0]     x_in,
    output         [7:0]     wire_o_1,
    output         [10:0]     wire_o_5,
    output         [10:0]     wire_o_7,
    output         [11:0]     wire_o_13,
    output         [12:0]     wire_o_17,
    output         [12:0]     wire_o_19,
    output         [12:0]     wire_o_21,
    output         [12:0]     wire_o_27,
    output         [13:0]     wire_o_41,
    output         [13:0]     wire_o_43,
    output         [13:0]     wire_o_45,
    output         [13:0]     wire_o_53,
    output         [13:0]     wire_o_61,
    output         [14:0]     wire_o_79,
    output         [14:0]     wire_o_93,
    output         [14:0]     wire_o_101,
    output         [14:0]     wire_o_103,
    output         [14:0]     wire_o_113,
    output         [15:0]     wire_o_133,
    output         [15:0]     wire_o_137,
    output         [15:0]     wire_o_199,
    output         [16:0]     wire_o_331,
    output         [16:0]     wire_o_333,
    output         [17:0]     wire_o_613,
    output         [18:0]     wire_o_1097,
    output         [18:0]     wire_o_1197
);


    // ============ Wires ============
    wire    [7:0]    wire_1_1;
    wire    [10:0]    wire_1_5;
    wire    [7:0]    wire_2_1;
    wire    [11:0]    wire_2_9;
    wire    [11:0]    wire_2_13;
    wire    [12:0]    wire_2_17;
    wire    [13:0]    wire_2_45;
    wire    [14:0]    wire_2_75;
    wire    [7:0]    wire_3_1;
    wire    [10:0]    wire_3_5;
    wire    [10:0]    wire_3_7;
    wire    [11:0]    wire_3_13;
    wire    [12:0]    wire_3_17;
    wire    [12:0]    wire_3_19;
    wire    [12:0]    wire_3_21;
    wire    [12:0]    wire_3_27;
    wire    [13:0]    wire_3_41;
    wire    [13:0]    wire_3_43;
    wire    [13:0]    wire_3_45;
    wire    [13:0]    wire_3_53;
    wire    [13:0]    wire_3_61;
    wire    [14:0]    wire_3_79;
    wire    [14:0]    wire_3_93;
    wire    [14:0]    wire_3_101;
    wire    [14:0]    wire_3_103;
    wire    [14:0]    wire_3_113;
    wire    [15:0]    wire_3_133;
    wire    [15:0]    wire_3_137;
    wire    [15:0]    wire_3_199;
    wire    [16:0]    wire_3_331;
    wire    [16:0]    wire_3_333;
    wire    [17:0]    wire_3_613;
    wire    [18:0]    wire_3_1097;
    wire    [18:0]    wire_3_1197;

    // ============ Registers ============
    reg     [7:0]    reg_1_1;
    reg     [10:2]    reg_1_5;
    reg     [7:0]    reg_2_1;
    reg     [11:3]    reg_2_9;
    reg     [11:2]    reg_2_13;
    reg     [12:4]    reg_2_17;
    reg     [13:5]    reg_2_45;
    reg     [14:1]    reg_2_75;
    reg     [7:0]    reg_3_1;
    reg     [10:2]    reg_3_5;
    reg     [10:1]    reg_3_7;
    reg     [11:3]    reg_3_13;
    reg     [12:4]    reg_3_17;
    reg     [12:2]    reg_3_19;
    reg     [12:4]    reg_3_21;
    reg     [12:3]    reg_3_27;
    reg     [13:3]    reg_3_41;
    reg     [13:4]    reg_3_43;
    reg     [13:5]    reg_3_45;
    reg     [13:5]    reg_3_53;
    reg     [13:4]    reg_3_61;
    reg     [14:3]    reg_3_79;
    reg     [14:5]    reg_3_93;
    reg     [14:5]    reg_3_101;
    reg     [14:5]    reg_3_103;
    reg     [14:5]    reg_3_113;
    reg     [15:7]    reg_3_133;
    reg     [15:5]    reg_3_137;
    reg     [15:6]    reg_3_199;
    reg     [16:5]    reg_3_331;
    reg     [16:6]    reg_3_333;
    reg     [17:9]    reg_3_613;
    reg     [18:6]    reg_3_1097;
    reg     [18:7]    reg_3_1197;

    // ============ Combinational Logic ============
    assign wire_1_1 = x_in;
    assign wire_1_5 = (x_in<<2) + x_in;
    assign wire_2_1 = reg_1_1;
    assign wire_2_9 = (reg_1_1<<3) + reg_1_1;
    assign wire_2_13 = (reg_1_1<<3) + {reg_1_5, reg_1_1[1], reg_1_1[0]};
    assign wire_2_17 = (reg_1_1<<4) + reg_1_1;
    assign wire_2_45 = ({reg_1_5, reg_1_1[1], reg_1_1[0]}<<3) + {reg_1_5, reg_1_1[1], reg_1_1[0]};
    assign wire_2_75 = ({reg_1_5, reg_1_1[1], reg_1_1[0]}<<4) - {reg_1_5, reg_1_1[1], reg_1_1[0]};
    assign wire_3_1 = reg_2_1;
    assign wire_3_5 = (reg_2_1<<2) + reg_2_1;
    assign wire_3_7 = (reg_2_1<<3) - reg_2_1;
    assign wire_3_13 = {reg_2_13, reg_2_1[1], reg_2_1[0]};
    assign wire_3_17 = {reg_2_17, reg_2_1[3], reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_19 = (reg_2_1<<5) - {reg_2_13, reg_2_1[1], reg_2_1[0]};
    assign wire_3_21 = (reg_2_1<<3) + {reg_2_13, reg_2_1[1], reg_2_1[0]};
    assign wire_3_27 = ({reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]}<<1) + {reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_41 = (reg_2_1<<5) + {reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_43 = ({reg_2_13, reg_2_1[1], reg_2_1[0]}<<1) + {reg_2_17, reg_2_1[3], reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_45 = {reg_2_45, reg_2_13[4], reg_2_13[3], reg_2_13[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_53 = (reg_2_1<<3) + {reg_2_45, reg_2_13[4], reg_2_13[3], reg_2_13[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_61 = (reg_2_1<<4) + {reg_2_45, reg_2_13[4], reg_2_13[3], reg_2_13[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_79 = ({reg_2_17, reg_2_1[3], reg_2_1[2], reg_2_1[1], reg_2_1[0]}<<1) + {reg_2_45, reg_2_13[4], reg_2_13[3], reg_2_13[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_93 = ({reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]}<<1) + {reg_2_75, reg_2_1[0]};
    assign wire_3_101 = ({reg_2_13, reg_2_1[1], reg_2_1[0]}<<1) + {reg_2_75, reg_2_1[0]};
    assign wire_3_103 = ({reg_2_13, reg_2_1[1], reg_2_1[0]}<<3) - reg_2_1;
    assign wire_3_113 = ({reg_2_13, reg_2_1[1], reg_2_1[0]}<<3) + {reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_133 = ({reg_2_13, reg_2_1[1], reg_2_1[0]}<<4) - {reg_2_75, reg_2_1[0]};
    assign wire_3_137 = (reg_2_1<<7) + {reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_199 = ({reg_2_13, reg_2_1[1], reg_2_1[0]}<<4) - {reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_331 = (reg_2_1<<8) + {reg_2_75, reg_2_1[0]};
    assign wire_3_333 = ({reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]}<<5) + {reg_2_45, reg_2_13[4], reg_2_13[3], reg_2_13[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_613 = ({reg_2_75, reg_2_1[0]}<<3) + {reg_2_13, reg_2_1[1], reg_2_1[0]};
    assign wire_3_1097 = ({reg_2_17, reg_2_1[3], reg_2_1[2], reg_2_1[1], reg_2_1[0]}<<6) + {reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]};
    assign wire_3_1197 = ({reg_2_9, reg_2_1[2], reg_2_1[1], reg_2_1[0]}<<7) + {reg_2_45, reg_2_13[4], reg_2_13[3], reg_2_13[2], reg_2_1[1], reg_2_1[0]};

    // ============ Sequential Logic ============
    always@(posedge clk) begin
        reg_1_1 <= wire_1_1[7:0];
        reg_1_5 <= wire_1_5[10:2];
        reg_2_1 <= wire_2_1[7:0];
        reg_2_9 <= wire_2_9[11:3];
        reg_2_13 <= wire_2_13[11:2];
        reg_2_17 <= wire_2_17[12:4];
        reg_2_45 <= wire_2_45[13:5];
        reg_2_75 <= wire_2_75[14:1];
        reg_3_1 <= wire_3_1[7:0];
        reg_3_5 <= wire_3_5[10:2];
        reg_3_7 <= wire_3_7[10:1];
        reg_3_13 <= wire_3_13[11:3];
        reg_3_17 <= wire_3_17[12:4];
        reg_3_19 <= wire_3_19[12:2];
        reg_3_21 <= wire_3_21[12:4];
        reg_3_27 <= wire_3_27[12:3];
        reg_3_41 <= wire_3_41[13:3];
        reg_3_43 <= wire_3_43[13:4];
        reg_3_45 <= wire_3_45[13:5];
        reg_3_53 <= wire_3_53[13:5];
        reg_3_61 <= wire_3_61[13:4];
        reg_3_79 <= wire_3_79[14:3];
        reg_3_93 <= wire_3_93[14:5];
        reg_3_101 <= wire_3_101[14:5];
        reg_3_103 <= wire_3_103[14:5];
        reg_3_113 <= wire_3_113[14:5];
        reg_3_133 <= wire_3_133[15:7];
        reg_3_137 <= wire_3_137[15:5];
        reg_3_199 <= wire_3_199[15:6];
        reg_3_331 <= wire_3_331[16:5];
        reg_3_333 <= wire_3_333[16:6];
        reg_3_613 <= wire_3_613[17:9];
        reg_3_1097 <= wire_3_1097[18:6];
        reg_3_1197 <= wire_3_1197[18:7];
    end

    // ============ Outputs ============
    assign wire_o_1 = reg_3_1;
    assign wire_o_5 = {reg_3_5, reg_3_1[1], reg_3_1[0]};
    assign wire_o_7 = {reg_3_7, reg_3_1[0]};
    assign wire_o_13 = {reg_3_13, reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_17 = {reg_3_17, reg_3_1[3], reg_3_1[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_19 = {reg_3_19, reg_3_7[1], reg_3_1[0]};
    assign wire_o_21 = {reg_3_21, reg_3_5[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_27 = {reg_3_27, reg_3_19[2], reg_3_7[1], reg_3_1[0]};
    assign wire_o_41 = {reg_3_41, reg_3_1[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_43 = {reg_3_43, reg_3_27[3], reg_3_19[2], reg_3_7[1], reg_3_1[0]};
    assign wire_o_45 = {reg_3_45, reg_3_13[4], reg_3_13[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_53 = {reg_3_53, reg_3_21[4], reg_3_5[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_61 = {reg_3_61, reg_3_13[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_79 = {reg_3_79, reg_3_7[2], reg_3_7[1], reg_3_1[0]};
    assign wire_o_93 = {reg_3_93, reg_3_61[4], reg_3_13[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_101 = {reg_3_101, reg_3_5[4], reg_3_5[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_103 = {reg_3_103, reg_3_7[4], reg_3_7[3], reg_3_7[2], reg_3_7[1], reg_3_1[0]};
    assign wire_o_113 = {reg_3_113, reg_3_17[4], reg_3_1[3], reg_3_1[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_133 = {reg_3_133, reg_3_5[6], reg_3_5[5], reg_3_5[4], reg_3_5[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_137 = {reg_3_137, reg_3_41[4], reg_3_41[3], reg_3_1[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_199 = {reg_3_199, reg_3_7[5], reg_3_7[4], reg_3_7[3], reg_3_7[2], reg_3_7[1], reg_3_1[0]};
    assign wire_o_331 = {reg_3_331, reg_3_43[4], reg_3_27[3], reg_3_19[2], reg_3_7[1], reg_3_1[0]};
    assign wire_o_333 = {reg_3_333, reg_3_13[5], reg_3_13[4], reg_3_13[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_613 = {reg_3_613, reg_3_101[8], reg_3_101[7], reg_3_101[6], reg_3_101[5], reg_3_5[4], reg_3_5[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_1097 = {reg_3_1097, reg_3_137[5], reg_3_41[4], reg_3_41[3], reg_3_1[2], reg_3_1[1], reg_3_1[0]};
    assign wire_o_1197 = {reg_3_1197, reg_3_45[6], reg_3_45[5], reg_3_13[4], reg_3_13[3], reg_3_5[2], reg_3_1[1], reg_3_1[0]};

endmodule
