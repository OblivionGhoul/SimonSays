module TB_Random;

    logic clk;
    logic rst;
    logic [1:0] random_seq;

    Random dut (
        .clk(clk),
        .rst(rst),
        .random_seq(random_seq)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        $display("Starting Random Sequence Generator Test...");
        
        rst = 1;
        #10;
        rst = 0;

        repeat (10) begin
            @(posedge clk);
            #1;
            $display("Time: %0t | Random Sequence: %b", $time, random_seq);
        end

        $display("Test Completed.");
        $stop;
    end

endmodule
