module dbram16 #(
	parameter init_file = "none",
	parameter adr_width = 11
) (
	input a_clk,
	input a_rst,
  input [15:0] a_do,
  output reg [15:0] a_di,
  input a_we,
  input [15:0] a_a,

	input b_clk,
	input b_rst,
  input [15:0] b_do,
  output reg [15:0] b_di,
  input b_we,
  input [15:0] b_a
);

//-----------------------------------------------------------------
// Storage depth in 16 bit words
//-----------------------------------------------------------------
parameter word_width = adr_width - 1;
parameter word_depth = (1 << word_width);

//-----------------------------------------------------------------
// Actual RAM
//-----------------------------------------------------------------
reg [15:0] ram [0:word_depth-1];
wire [word_width-1:0] adr_a;
wire [word_width-1:0] adr_b;

always @(posedge a_clk) begin
  if (a_we) begin
    ram[adr_a] <= a_do;
  end
	a_di <= ram[adr_a];
end

always @(posedge b_clk) begin
  if (b_we) begin
    ram[adr_b] <= b_do;
  end
	b_di <= ram[adr_b];
end

assign adr_a = a_a[adr_width-1:1];
assign adr_b = a_a[adr_width-1:1];

//-----------------------------------------------------------------
// RAM initialization
//-----------------------------------------------------------------
initial
begin
	if (init_file != "none")
	begin
		$readmemh(init_file, ram);
	end
end

endmodule
