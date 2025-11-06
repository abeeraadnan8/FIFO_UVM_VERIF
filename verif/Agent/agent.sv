class agent extends uvm_agent;
  `uvm_component_utils(agent)
  
  
  function new(string name= "agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  monitor fifo_monitor;
  driver fifo_driver;
  uvm_sequencer#(sequence_item) fifo_sequencer;
  
  //build phase
  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    fifo_monitor = monitor :: type_id :: create ("fifo_monitor", this);
    fifo_driver = driver :: type_id :: create ("fifo_driver", this);
    fifo_sequencer = uvm_sequencer#(sequence_item) :: type_id :: create("fifo_sequencer", this);
  endfunction 
  
  //connect phase
  
  virtual function void connect_phase (uvm_phase phase);
    super.connect_phase(phase);
    fifo_driver.seq_item_port.connect(fifo_sequencer.seq_item_export);
  endfunction
  
endclass