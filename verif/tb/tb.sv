`timescale 1ns/1ns
 import uvm_pkg::*;
`include "uvm_macros.svh"
`include "intf.sv"
`include "sequence_item.sv"
`include "sequence.sv"
`include "driver.sv"
`include "monitor.sv"
`include "agent.sv"
`include "scoreboard.sv"
`include "env.sv"
`include "fifo_test.sv"

module tb;
  

  intf fifo_intf();
  
  fifo #(
  .DEPTH(8),
  .DATA_WIDTH(15)
) dut (
  .clk(fifo_intf.clk),
  .datain(fifo_intf.datain),
  .wr_en(fifo_intf.wr_en),
  .rd_en(fifo_intf.rd_en),
  .resetn(fifo_intf.resetn),
  .dataout(fifo_intf.dataout),
  .full(fifo_intf.full),
  .empty(fifo_intf.empty)
);

  
  initial begin
    fifo_intf.clk = 0;
  end
  
  always begin
    #10
    fifo_intf.clk = ~fifo_intf.clk;
  end 
  
  initial begin
    fifo_intf.resetn = 0;
    repeat(1) @(posedge fifo_intf.clk);
    fifo_intf.resetn = 1;
  end 
  
  initial begin
    uvm_config_db#(virtual intf)::set(null, "*", "vif", tb.fifo_intf);
    run_test("fifo_test");
  end
  
  
  initial begin
    $dumpfile("d.vcd");
    $dumpvars();
  end 
  
endmodule 
  
