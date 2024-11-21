module LED_and_Display_Control (
    input  logic       clk,
    input  logic       rst,
    input  logic [3:0] seq_led,
    input  logic [3:0] user_input,
    input  logic       display_loss,
    input  logic [3:0] score,
    output logic [3:0] led,
    output logic [6:0] seg_display
);

    // LED control
    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            led <= 4'b0000;
        end else begin
            led <= display_loss ? 4'b1111 : seq_led;
        end
    end

    // 7-segment display logic for score
    always_comb begin
        case (score)
            4'd0: seg_display = 7'b0111111; // 0
            4'd1: seg_display = 7'b0000110; // 1
            4'd2: seg_display = 7'b1011011; // 2
            4'd3: seg_display = 7'b1001111; // 3
            4'd4: seg_display = 7'b1100110; // 4
            4'd5: seg_display = 7'b1101101; // 5
            4'd6: seg_display = 7'b1111101; // 6
            4'd7: seg_display = 7'b0000111; // 7
            4'd8: seg_display = 7'b1111111; // 8
            4'd9: seg_display = 7'b1101111; // 9
            default: seg_display = 7'b0000000; // Off
        endcase
    end

endmodule
