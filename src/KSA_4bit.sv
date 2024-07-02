module KSA_4bit#(parameter size = 4)(
	input logic [size - 1:0] A, B,
	input logic Cin,
	output logic [size -1:0] S,
	output logic Co
);
logic [size - 1:0]P, C,  G_pre,  P_pre,G;
logic [size - 3:0] P2,G2;

generate
	genvar i;
		for(i = 0; i < size; i = i + 1) begin : generate_Pre_Processing
			Pre_Processing Pre_Processing_Module(.A(A[i]),.B(B[i]), .P(P_pre[i]), .G(G_pre[i]));
			end
endgenerate
generate 
	genvar k;
		for(k = 0; k < size; k = k + 1) begin : FCO
			if (k == 0)
			FCO FCO_module(.P_pre(1'b1), .G_pre(1'b0), .Pi(P_pre[k]), .Gi(G_pre[k]), .Po(P[k]),.Go(G[k]));
			else
			FCO FCO_module(.P_pre(P_pre[k - 1]), .G_pre(G_pre[k - 1]), .Pi(P_pre[k]), .Gi(G_pre[k]), .Po(P[k]),.Go(G[k]));
		end
endgenerate
generate 
	genvar h;
		for(h = 0; h < size - 2; h = h + 1) begin : FCO_2
			FCO FCO_module(.P_pre(P[h]), .G_pre(G[h]), .Pi(P[h + 2]), .Gi(G[h + 2]), .Po(P2[h]),.Go(G2[h]));
			end
endgenerate
generate
	genvar j;
		for(j = 0; j <size; j = j +1) begin : final_processing
			if (j == 0)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P[j]),.Gi(G[j]), .C_pre(Cin), .Si(S[j]), .Ci(C[j]));
			else if (j > 1)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P2[j-2]),.Gi(G2[j-2]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
			else
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P[j]),.Gi(G[j]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
		end
endgenerate
assign Co = C[3];
endmodule
