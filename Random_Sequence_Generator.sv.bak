module Random_Sequence_Generator (
    input  logic        clk,
    input  logic        rst,
    output logic [1:0]  random_seq
);

    logic [31:0] random_seed;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            random_seed <= 32'h1; // Initialize with a non-zero seed
        end else begin
            random_seed <= {random_seed[30:0], random_seed[31] ^ random_seed[21]};
        end
    end

    assign random_seq = random_seed[1:0]; // Take the 2 LSBs for randomness

endmodule