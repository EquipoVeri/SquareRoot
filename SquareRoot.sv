module SquareRoot
#(
	parameter WORD_LENGTH = 16
) 
(	// Input ports
	input clk,
	input reset,
	input [(WORD_LENGTH/2)-1 : 0] DataInput,
	
	// Output ports
	output [WORD_LENGTH-1 : 0] result,
	output [WORD_LENGTH-1 : 0] residue
);

bit flag0_bit;
bit enable_bit;
bit enableR_bit;
wire [(WORD_LENGTH/2)-1 : 0] R_w;
wire [(WORD_LENGTH/2)-1 : 0] result_w;
wire [(WORD_LENGTH/2)-1 : 0] residue_w;
wire [(WORD_LENGTH/2)-1 : 0] Rreg_w;
wire [(WORD_LENGTH/2)-1 : 0] Qreg_w;
wire [(WORD_LENGTH/2)-1 : 0] final_residue_w;
wire [(WORD_LENGTH/2)-1 : 0] adder1_w;
wire [(WORD_LENGTH/2)-1 : 0] q1_w;
wire [(WORD_LENGTH/2)-1 : 0] R1_w;
wire [4:0] counter_w2;
wire [(WORD_LENGTH/2)-1 : 0] R_w1;
wire [(WORD_LENGTH/2)-1 : 0] R_w2;
wire [(WORD_LENGTH/2)-1 : 0] finalR_w;
wire [(WORD_LENGTH/2)-1 : 0] finalRQ_w;
wire [(WORD_LENGTH/2)-1 : 0] q_w;
wire [4:0] counter_w1;
wire [(WORD_LENGTH/2)-1 : 0] DInput_w = DataInput[(WORD_LENGTH/2)-1:0];
bit signQ_bit; 

assign signQ_bit = ~R_w[7];
assign q_w = (q1_w << 1) | signQ_bit;
assign counter_w2 = counter_w1 << 1;
assign R_w1 = (R1_w << 2);
assign R_w2 = (R_w1 | ((DInput_w >> counter_w2) & 3));

Multiplexer2to1
#(
	.NBits(WORD_LENGTH/2)
)
mux_Rinitial
(
	.Selector(flag0_bit),
	.MUX_Data0(Rreg_w),
	.MUX_Data1({(WORD_LENGTH/2){1'b0}}),
	.MUX_Output(R1_w)
);

Multiplexer2to1
#(
	.NBits(WORD_LENGTH/2)
)
mux_Qinitial
(
	.Selector(flag0_bit),
	.MUX_Data0(Qreg_w),
	.MUX_Data1({(WORD_LENGTH/2){1'b0}}),
	.MUX_Output(q1_w)
);

Multiplexer2to1
#(
	.NBits((WORD_LENGTH/2))
)
mux_q
(
	.Selector(R1_w[(WORD_LENGTH/2)-1]),
	.MUX_Data0((q1_w << 2) | 1),
	.MUX_Data1((q1_w << 2) | 3),
	.MUX_Output(adder1_w)
);


Multiplexer2to1
#(
	.NBits((WORD_LENGTH/2))
)
final_R
(
	.Selector(R1_w[7] & enableR_bit),
	.MUX_Data0(R_w2),
	.MUX_Data1(R1_w),
	.MUX_Output(finalR_w)
);

Multiplexer2to1
#(
	.NBits((WORD_LENGTH/2))
)
final_RQ
(
	.Selector(R1_w[7] & enableR_bit),
	.MUX_Data0(adder1_w),
	.MUX_Data1((q1_w << 1) | 1),
	.MUX_Output(finalRQ_w)
);

Adder
#(
	.WORD_LENGTH((WORD_LENGTH/2))
)
adder_sqroot
(
	.selector(R1_w[(WORD_LENGTH/2)-1]),
	.Data1(finalR_w),
	.Data2(finalRQ_w),
	.result(R_w)
);

CounterWithFunction counter_sqroot
(
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.flag0(flag0_bit),
	.flag8(enable_bit),
	.flag9(enableR_bit),
	.count(counter_w1)
);

Register
#(
	.Word_Length((WORD_LENGTH/2))
)
R_reg
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(R_w),

	// Output Ports
	.Data_Output(Rreg_w)
);

Register
#(
	.Word_Length((WORD_LENGTH/2))
)
Q_reg
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(1'b1),
	.Data_Input(q_w),

	// Output Ports
	.Data_Output(Qreg_w)
);


Register
#(
	.Word_Length((WORD_LENGTH/2))
)
result_reg
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(enable_bit),
	.Data_Input(q_w),

	// Output Ports
	.Data_Output(result_w)
);

Multiplexer2to1
#(
	.NBits((WORD_LENGTH/2))
)
final_residue
(
	.Selector(Rreg_w[(WORD_LENGTH/2)-1]),
	.MUX_Data0(Rreg_w),
	.MUX_Data1(R_w),
	.MUX_Output(final_residue_w)
);

Register
#(
	.Word_Length((WORD_LENGTH/2))
)
residue_reg
(
	// Input Ports
	.clk(clk),
	.reset(reset),
	.enable(enableR_bit),
	.Data_Input(final_residue_w),

	// Output Ports
	.Data_Output(residue_w)
);

assign result = result_w;
assign residue = residue_w;

endmodule
