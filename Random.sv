module Random (
    input  logic        clk,
    input  logic        rst,
    output logic [1:0]  random_seq
);

    logic [3:0] lfsr; // 使用 4 位 LFSR 产生随机序列

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            lfsr <= 4'b1011; // 初始种子（可自定义）
        end else begin
            // LFSR 的反馈公式
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    end

    assign random_seq = lfsr[1:0]; // 取低两位作为随机数

endmodule
