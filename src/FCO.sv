module FCO (
	input logic P_pre, G_pre, Pi, Gi,
	output logic Po, Go
);
assign Po = Pi & P_pre;
assign Go = (G_pre & Pi) | Gi;
endmodule
