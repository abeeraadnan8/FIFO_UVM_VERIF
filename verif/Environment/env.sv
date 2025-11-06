class env extends uvm_env;
  `uvm_component_utils(env)
  
  int WATCH_DOG;
  uvm_event event_trig;
  
  
  function new(string name = "env", uvm_component parent = null);
    super.new(name, parent);
  endfunction
  
  
  agent fifo_agent;
  scoreboard fifo_scoreboard;
  
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    
    fifo_agent = agent :: type_id :: create ("fifo_agent", this);
    fifo_scoreboard = scoreboard :: type_id :: create ("fifo_scoreboard", this);
    event_trig = uvm_event_pool::get_global("in_scb_evnt");

    
  endfunction 
  
  
  //connect phase
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    fifo_agent.fifo_monitor.fifo_port.connect(fifo_scoreboard.scb_port);
  endfunction 
  
  
endclass