module Pre_Processing (
	input logic A, B,
	output logic P,G
);
assign P = A ^ B;
assign G = A & B;
endmodule
