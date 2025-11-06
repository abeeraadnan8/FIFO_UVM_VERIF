interface intf #(parameter DATA_WIDTH = 15);

  logic [DATA_WIDTH-1:0] datain;
  logic wr_en;
  logic rd_en;
  logic clk;
  logic resetn;
  logic [DATA_WIDTH-1:0] dataout;
  logic full;
  logic empty;

endinterface