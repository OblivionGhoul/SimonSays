module TB_Seg;

    // Inputs
    logic [5:0] result_data;

    // Outputs
    logic [6:0] high_digit_display;
    logic [6:0] low_digit_display;

    // Instantiate the 7-segment display module
    sevenSeg seg7_instance(
        .result_data(result_data),
        .high_digit_display(high_digit_display),
        .low_digit_display(low_digit_display)
    );

    // Task for testing the 7-segment display
    task Test_Seg7(
        input logic [5:0] input_result,
        input logic [6:0] expected_high,
        input logic [6:0] expected_low
    );
        begin
            result_data <= input_result;
            #10; // Wait for the output to stabilize

            if ((high_digit_display === expected_high) && (low_digit_display === expected_low)) begin
                $display("PASS: Input = %b, High = %b, Low = %b", input_result, high_digit_display, low_digit_display);
            end else begin
                $display("FAIL: Input = %b, Expected High = %b, Actual High = %b, Expected Low = %b, Actual Low = %b",
                         input_result, expected_high, high_digit_display, expected_low, low_digit_display);
            end
        end
    endtask

    initial begin
        $display("Starting 7-Segment Display Tests...");

        // Test cases for the 7-segment display
        Test_Seg7(6'd6, 7'b1000000, 7'b0000010); // 6 | High = 0 | Low = 6
        Test_Seg7(6'd9, 7'b1000000, 7'b0010000); // 9 | High = 0 | Low = 9
        Test_Seg7(6'd12, 7'b1111001, 7'b0100100); // 12 | High = 1 | Low = 2
        Test_Seg7(6'd27, 7'b0100100, 7'b1111000); // 27 | High = 2 | Low = 7
        Test_Seg7(6'd35, 7'b0110000, 7'b0010010); // 35 | High = 3 | Low = 5
        Test_Seg7(6'd48, 7'b0011001, 7'b0000000); // 48 | High = 4 | Low = 8

        $display("7-Segment Display Tests Completed.");
        $stop;
    end

endmodule
