module TB_Sound;

    logic clk;
    logic reset;
    logic [3:0] sound_select;
    logic sound_output;
    logic [9:0] frequency_output;

    Sound dut (
        .clk(clk),
        .rst(reset),
        .led_color(sound_select),
        .sound(sound_output),
        .frequency(frequency_output)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    task play_sound(input logic [3:0] select);
        @(negedge clk);
        sound_select <= select;
        @(posedge clk);
        #1;
        $display("Time=%0t | Sound Select=%b | Sound Output=%b | Frequency=%d", 
                  $time, sound_select, sound_output, frequency_output);
    endtask

    task reset_test();
        @(negedge clk);
        reset <= 1'b1;
        @(posedge clk);
        #1;
        $display("Time=%0t | Reset Activated | Sound Output=%b | Frequency=%d", 
                  $time, sound_output, frequency_output);
        reset <= 1'b0;
    endtask

    initial begin
        $display("Starting Sound Controller Tests...");
        reset = 1'b0;
        sound_select = 4'b0000;

        reset_test();
        play_sound(4'b0001);
        play_sound(4'b0010);
        play_sound(4'b0100);
        play_sound(4'b1000);
        play_sound(4'b1111);

        $display("Sound Controller Tests Completed.");
        $stop;
    end

endmodule
