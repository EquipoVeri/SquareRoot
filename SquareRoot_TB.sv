timeunit 10ps; //It specifies the time unit that all the delay will take in the simulation.
timeprecision 1ps;// It specifies the resolution in the simulation.

module SquareRoot_TB;


parameter WORD_LENGTH = 16;

bit clk = 0;
bit reset; 

logic [WORD_LENGTH-1:0] DataInput = 0;
logic [WORD_LENGTH-1:0] result = 0;
logic [WORD_LENGTH-1:0] residue = 0;

SquareRoot
#(
	.WORD_LENGTH(WORD_LENGTH)
)
DUV
(
	// Inputs
	.clk(clk),
	.reset(reset),
	.DataInput(DataInput),
	// Output
	.result(result),
	.residue(residue)
);


/*********************************************************/
initial // Clock generator
  begin
    forever #2 clk = !clk;
  end
/*********************************************************/
initial begin // reset generator
	#0 reset = 1;
	/*#30 reset = 0;
	#5 reset = 1;*/
end

/*********************************************************/

initial begin 
	#0 DataInput = 32767;
	
end

/*********************************************************/
endmodule
