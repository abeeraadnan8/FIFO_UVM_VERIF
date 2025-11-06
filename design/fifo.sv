module fifo #(
  parameter int DEPTH = 8,
  parameter int DATA_WIDTH = 15
)(
  input  logic                  clk,
  input  logic                  resetn,
  input  logic [DATA_WIDTH:0]   datain,
  input  logic                  wr_en,
  input  logic                  rd_en,
  output logic [DATA_WIDTH:0]   dataout,
  output logic                  full,
  output logic                  empty
);

  // Local parameters and internal signals
  localparam PTR_WIDTH = $clog2(DEPTH);

  logic [PTR_WIDTH-1:0] wr_ptr, rd_ptr;
  logic [DATA_WIDTH:0]  fifo_mem [DEPTH-1:0];
  logic [PTR_WIDTH:0]   counter;  // extra bit for full detection

  // Status signals
  assign full  = (counter == DEPTH);
  assign empty = (counter == 0);

  // Sequential logic
  always_ff @(posedge clk or negedge resetn) begin
    if (!resetn) begin
      wr_ptr   <= '0;
      rd_ptr   <= '0;
      counter  <= '0;
      dataout  <= '0;
    end else begin
      // Write operation
if (wr_en && !full) begin
  fifo_mem[wr_ptr] <= datain;
  wr_ptr <= wr_ptr + 1;

  // Display the write operation
  $display("[%0t] WRITE: fifo_mem[%0d] <= 0x%0h", $time, wr_ptr, datain);
end

// Read operation
if (rd_en && !empty) begin
  dataout <= fifo_mem[rd_ptr];
  rd_ptr <= rd_ptr + 1;

  // Display the read operation
  $display("[%0t] READ : fifo_mem[%0d] => 0x%0h", $time, rd_ptr, fifo_mem[rd_ptr]);
end


      // Counter management
      case ({wr_en && !full, rd_en && !empty})
        2'b10: counter <= counter + 1; // write only
        2'b01: counter <= counter - 1; // read only
        default: counter <= counter;   // both or none
      endcase
    end
  end

endmodule

  
  
      