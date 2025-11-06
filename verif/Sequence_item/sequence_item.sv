class sequence_item extends uvm_sequence_item;
  `uvm_object_utils(sequence_item)
  
  
  // --------------------------------------------------
  // AHB Transaction Fields
  // --------------------------------------------------
  
  rand bit [31:0] datain;
  rand bit wr_en;
  rand bit rd_en;
  bit [31:0] dataout;
  bit full;
  bit empty;
  //constructor
  
  function new(string name = "sequence_item");
    super.new(name);
  endfunction
  
 endclass 