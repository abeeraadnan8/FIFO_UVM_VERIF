class fifo_test extends uvm_test;
  `uvm_component_utils(fifo_test)

  // Handles to environment and sequence
  env   fifo_env;
  seque fifo_seq;

  // --------------------------------------------------------
  // Constructor
  // --------------------------------------------------------
  function new(string name = "fifo_test", uvm_component parent = null);
    super.new(name, parent);
    `uvm_info("FIFO_TEST", "Inside Constructor!", UVM_HIGH)
  endfunction 

  // --------------------------------------------------------
  // Build Phase
  // --------------------------------------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("FIFO_TEST", "Build Phase!", UVM_HIGH)

    // Create the environment
    fifo_env = env::type_id::create("fifo_env", this);
  endfunction : build_phase

  // --------------------------------------------------------
  // Connect Phase
  // --------------------------------------------------------
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("FIFO_TEST", "Connect Phase!", UVM_HIGH)
  endfunction 

  // --------------------------------------------------------
  // Run Phase
  // --------------------------------------------------------
  task run_phase(uvm_phase phase);
    `uvm_info("FIFO_TEST", "Run Phase Started!", UVM_HIGH)
    phase.raise_objection(this);

    // Create and start sequence 
    fifo_seq = seque::type_id::create("fifo_seq");
    fifo_seq.start(fifo_env.fifo_agent.fifo_sequencer);

    phase.drop_objection(this);
    `uvm_info("FIFO_TEST", "Run Phase Completed!", UVM_HIGH)
  endtask : run_phase

endclass