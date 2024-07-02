module PPC (
	input logic P, G, Cin,
	output logic Co
);
assign Co = G | (P & Cin);
endmodule
