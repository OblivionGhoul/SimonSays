module TB_FSM;

    // Inputs
    logic clk;
    logic rst;
    logic [3:0] btn;
    logic [1:0] random_seq;

    // Outputs
    logic [3:0] led;
    logic start_round;
    logic display_loss;
    logic mem_write;
    logic [4:0] mem_addr;

    // Inputs
    logic [1:0] mem_data;

    // Instantiate the FSM
    FSM dut (
        .clk(clk),
        .rst(rst),
        .btn(btn),
        .random_seq(random_seq),
        .led(led),
        .start_round(start_round),
        .display_loss(display_loss),
        .mem_write(mem_write),
        .mem_addr(mem_addr),
        .mem_data(mem_data)
    );

    // Clock generation
    always #10 clk = ~clk; // 50 MHz clock

    // Test Tasks
    task reset_fsm();
        begin
            @(negedge clk);
            rst = 1'b1;
            @(negedge clk);
            rst = 1'b0;
            $display("FSM Reset at time: %t", $time);
        end
    endtask

    task press_button(input logic [3:0] button);
        begin
            @(negedge clk);
            btn = button;
            @(negedge clk);
            btn = 4'b0000;
            $display("Button %b pressed at time: %t", button, $time);
        end
    endtask

    task validate_sequence(input logic [1:0] input_data, input logic match);
        begin
            mem_data = input_data;
            @(negedge clk);
            if (display_loss === ~match) begin
                $display("PASS: Input %b %s match at time: %t", input_data, match ? "correctly" : "did not", $time);
            end else begin
                $display("FAIL: Input %b %s match at time: %t", input_data, match ? "correctly" : "did not", $time);
            end
        end
    endtask

    // Test Sequence
    initial begin
        // Initialize signals
        clk = 0;
        rst = 0;
        btn = 4'b0000;
        random_seq = 2'b00;
        mem_data = 2'b00;

        $display("Starting FSM Tests...");

        // Reset FSM
        reset_fsm();

        // Power-On State
        #20;
        press_button(4'b0001); // Transition to INIT state

        // INIT State
        #20;
        if (start_round) $display("PASS: INIT State triggered start_round at time: %t", $time);
        else $display("FAIL: INIT State did not trigger start_round at time: %t", $time);

        // PLAY_SEQUENCE State
        #50;
        random_seq = 2'b01; // Random sequence generated
        mem_data = 2'b01;   // Mock memory data
        #50;

        // WAIT_INPUT State
        press_button(4'b0010); // Simulate input from the player

        // VALIDATE_INPUT State
        validate_sequence(2'b01, 1'b1); // Correct input

        // NEXT_ROUND State
        #50;
        if (start_round) $display("PASS: NEXT_ROUND State triggered start_round at time: %t", $time);
        else $display("FAIL: NEXT_ROUND State did not trigger start_round at time: %t", $time);

        // GAME_OVER State
        #50;
        press_button(4'b1000); // Incorrect input
        validate_sequence(2'b11, 1'b0); // Incorrect match

        $display("FSM Tests Completed.");
        $stop;
    end

endmodule
