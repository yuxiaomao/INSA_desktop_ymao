module dbram32 #(
	parameter init_file = "none",
	parameter adr_width = 11
) (
	input a_clk,
	input a_rst,
  input [31:0] a_do,
  output reg [31:0] a_di,
  input a_we,
  input [15:0] a_a,

	input b_clk,
	input b_rst,
  input [31:0] b_do,
  output reg [31:0] b_di,
  input b_we,
  input [15:0] b_a
);

//-----------------------------------------------------------------
// Storage depth in 16 bit words
//-----------------------------------------------------------------
parameter word_width = adr_width - 2;
parameter word_depth = (1 << word_width);

//-----------------------------------------------------------------
// Actual RAM
//-----------------------------------------------------------------
reg [31:0] ram [0:word_depth-1];
wire [word_width-1:0] a_adr;
wire [word_width-1:0] b_adr;

always @(posedge a_clk) begin
  if (a_we) begin
    ram[a_adr] <= a_do;
  end
	a_di <= ram[adr_a];
end

always @(posedge sys_clk) begin
  if (a_we) begin
    ram[adr] <= do;
  end
	di <= ram[adr_b];
end

assign a_adr = a_a[adr_width-1:2];
assign b_adr = b_a[adr_width-1:2];

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
