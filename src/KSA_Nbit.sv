module KSA_Nbit#(parameter size = 32)(
	input logic [size - 1:0] A, B,
	input logic Cin,
	output logic [size -1:0] S,
	output logic Co
);
logic [size - 1:0]P, C,  G_pre,  P_pre,G;
logic [size - 3:0] P2,G2;
logic [size - 5:0] P3,G3;
logic [size - 9:0] P4,G4;
logic [size - 17:0] P5,G5;
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
        genvar x;
         for(x = 0; x < size - 4; x = x + 1) begin : FCO_3
				if (x < 2)
					FCO FCO_module(.P_pre(P[x]), .G_pre(G[x]), .Pi(P2[x + 2]), .Gi(G2[x + 2]), .Po(P3[x]),.Go(G3[x]));
				else 
					FCO FCO_module(.P_pre(P2[x - 2]), .G_pre(G2[x-2]), .Pi(P2[x + 2]), .Gi(G2[x + 2]), .Po(P3[x]),.Go(G3[x]));
            end
endgenerate
generate
        genvar l;
                for(l = 0; l < size - 8; l = l + 1) begin : FCO_4
			if (l<2)
         FCO FCO_module(.P_pre(P[l]), .G_pre(G[l]), .Pi(P3[l + 4]), .Gi(G3[l + 4]), .Po(P4[l]),.Go(G4[l]));
			else if (l < 4)
         FCO FCO_module(.P_pre(P2[l - 2]), .G_pre(G2[l - 2]), .Pi(P3[l + 4]), .Gi(G3[l + 4]), .Po(P4[l]),.Go(G4[l]));
			else
         FCO FCO_module(.P_pre(P3[l - 4]), .G_pre(G3[l - 4]), .Pi(P3[l + 4]), .Gi(G3[l + 4]), .Po(P4[l]),.Go(G4[l]));
                        end
endgenerate
generate
        genvar m;
         for(m = 0; m < size - 16; m = m + 1) begin : FCO_5
         if (m < 2)
         FCO FCO_module(.P_pre(P[m]), .G_pre(G[m]), .Pi(P4[m + 8]), .Gi(G4[m + 8]), .Po(P5[m]),.Go(G5[m]));
         else if ( m < 4)
         FCO FCO_module(.P_pre(P2[m - 2]), .G_pre(G2[m - 2]), .Pi(P4[m + 8]), .Gi(G4[m + 8]), .Po(P5[m]),.Go(G5[m]));
         else if ( m < 8)
			FCO FCO_module(.P_pre(P3[m - 4]), .G_pre(G3[m - 4]), .Pi(P4[m + 8]), .Gi(G4[m + 8]), .Po(P5[m]),.Go(G5[m]));
			else
			FCO FCO_module(.P_pre(P4[m - 8]), .G_pre(G4[m - 8]), .Pi(P4[m + 8]), .Gi(G4[m + 8]), .Po(P5[m]),.Go(G5[m]));
         end
			endgenerate
generate
	genvar j;
		for(j = 0; j <size; j = j +1) begin : final_processing
			if (j == 0)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P[j]),.Gi(G[j]), .C_pre(Cin), .Si(S[j]), .Ci(C[j]));
         else if (j < 2)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P[j]),.Gi(G[j]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
         else if (j < 4)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P2[j - 2]),.Gi(G2[j - 2]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
         else if (j < 8)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P3[j - 4]),.Gi(G3[j - 4]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
         else if (j < 16)
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P4[j - 8]),.Gi(G4[j - 8]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
         else   
			final_processing final_processing2(.Pi(P_pre[j]), .P_p(P5[j - 16]),.Gi(G5[j - 16]), .C_pre(C[j - 1]), .Si(S[j]), .Ci(C[j]));
		end
endgenerate
assign Co = C[size - 1];
endmodule

