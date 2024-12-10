module Random (
    input  logic        clk,
    input  logic        rst,
    output logic [1:0]  random_seq
);

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            random_seq <= 2'b00;
        end else begin
            random_seq <= $random % 4;
        end
    end

endmodule
