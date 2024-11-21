module top_level (
    input  logic CLK,
    input  logic RST,
    input  logic BTN0,
    input  logic BTN1,
    input  logic BTN2,
    input  logic BTN3,
    output logic LED0,
    output logic LED1,
    output logic LED2,
    output logic LED3,
    output logic SND
);

    fsm simon1 (
        .clk   (CLK),
        .rst   (RST),
        .ticks_per_milli (50),
        .btn   ({BTN3, BTN2, BTN1, BTN0}),
        .led   ({LED3, LED2, LED1, LED0}),
        .sound (SND)
    );

endmodule
