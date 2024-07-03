module final_processing(
	input logic Pi, P_p,Gi,C_pre,
	output logic Si, Ci
);
assign Ci = Gi | P_p * C_pre;
assign Si = Pi ^ C_pre;
endmodule

