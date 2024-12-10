module memory (
    input  logic        clk,
    input  logic        write_enable,
    input  logic [4:0]  addr,
    input  logic [1:0]  write_data,
    output logic [1:0]  read_data
);

    logic [1:0] mem_array [31:0];

    always_ff @(posedge clk) begin
        if (write_enable) begin
            mem_array[addr] <= write_data;
        end
    end

    assign read_data = mem_array[addr];

endmodule
