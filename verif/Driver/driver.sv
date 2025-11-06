class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver)
  
  virtual intf vif;
  sequence_item req, rsp;
  
  //constructor
  function new(string name = "driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction 
  
  
  //build_phase  
  virtual function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    
    req = sequence_item :: type_id :: create("req");
    rsp = sequence_item :: type_id :: create("rsp");
    
    if (!uvm_config_db #(virtual intf) :: get (this, "", "vif", vif))
                                               `uvm_fatal("interface", "no interface found")                                                                        
  endfunction
  
  // --------------------------
  // Run Phase
  // --------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Run Phase Started", UVM_LOW)


    @(posedge vif.resetn);
    `uvm_info(get_type_name(), "Reset De-asserted, Starting Transactions", UVM_LOW)

    // Drive transactions
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req);
      seq_item_port.item_done();
    end
  endtask

  // --------------------------
  // Drive FIFO Item
  // --------------------------
  virtual task drive_item(sequence_item req);

    @(posedge vif.clk);
    vif.wr_en <= $urandom;
    vif.rd_en <= $urandom;
    if (vif.wr_en) begin
    vif.datain <= $urandom;
    end else begin
      vif.datain <= '0;
    end
    
  endtask 
    

 endclass