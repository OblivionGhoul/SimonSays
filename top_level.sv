module top_level (
    input logic clk,          // 全局时钟信号
    input logic reset,        // 全局复位信号
    input logic [3:0] buttons,// 用户输入按钮
    output logic [6:0] seg,   // 7段显示器输出
    output logic [3:0] leds   // 状态指示灯
);

    // 时钟分频信号
    logic slow_clk;

    // FSM 状态输出
    logic [2:0] state;

    // 随机序列信号
    logic [5:0] random_sequence;

    // 内存信号
    logic [5:0] memory_out;

    // 同步复位信号
    logic sync_reset;

    // 同步复位模块
    a_assert_s_deassert a_assert_s_deassert_inst (
        .clk(clk),
        .key(reset),
        .key_sync(sync_reset)
    );

    // 时钟分频模块
    clockdiv clk_div_inst (
        .iclk(clk),
        .oclk(slow_clk)
    );

    // FSM 控制模块
    fsm fsm_inst (
        .clk(slow_clk),
        .rst(sync_reset),
        .btn(buttons),
        .random_seq(random_sequence[1:0]),
        .led(leds),
        .start_round(),
        .display_loss(),
        .mem_write(),
        .mem_addr(state),
        .mem_data(memory_out[1:0])
    );

    // 随机数生成模块
    Random random_inst (
        .clk(slow_clk),
        .rst(sync_reset),
        .random_seq(random_sequence)
    );

    // 内存模块
    memory memory_inst (
        .data_In(random_sequence),
        .w_ptr(state),
        .r_ptr(state),
        .w_en(state == 3'b010), // 假设某状态需要写入
        .r_en(state == 3'b011), // 假设某状态需要读取
        .clk(slow_clk),
        .data_Out(memory_out)
    );

    // 7段显示器模块
    sevenSeg seven_seg_inst (
        .result_data(memory_out),
        .high_digit_display(seg[6:0]),
        .low_digit_display()
    );

endmodule
