module Sync(
	input logic async_signal,
	input logic clock_signal,
	output logic synchronized_signal
);

	logic intermediate_sync_0, intermediate_sync_1, intermediate_sync_2;

	always_ff @(posedge clock_signal) begin
		intermediate_sync_0 <= async_signal;
		intermediate_sync_1 <= intermediate_sync_0;
		intermediate_sync_2 <= intermediate_sync_1;
	end

	assign synchronized_signal = (!intermediate_sync_1 && intermediate_sync_2);

endmodule
