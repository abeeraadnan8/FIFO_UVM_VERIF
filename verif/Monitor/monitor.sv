class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)

  virtual intf vif;
  uvm_analysis_port#(sequence_item) fifo_port;
  sequence_item tr;

  // --------------------------
  // Constructor
  // --------------------------
  function new(string name = "monitor", uvm_component parent = null);
    super.new(name, parent);
    fifo_port = new("fifo_port", this);
  endfunction

  // --------------------------
  // Build Phase
  // --------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    tr = sequence_item::type_id::create("tr", this);

    if (!uvm_config_db#(virtual intf)::get(this, "", "vif", vif)) begin
      `uvm_fatal("MON_NO_VIF", "Virtual interface not set for monitor")
    end
  endfunction

  // --------------------------
  // Run Phase
  // --------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "APB Monitor started", UVM_LOW)

    forever begin
      @(posedge vif.clk iff (vif.wr_en || vif.rd_en)); //wr and rd enable so we dont get x or z data at the start
      tr.datain  = vif.datain;
      tr.wr_en = vif.wr_en;
      tr.rd_en = vif.rd_en;
      if (vif.rd_en) begin
        tr.dataout = vif.dataout;
      end 
        
      tr.full = vif.full;
      tr.empty = vif.empty;
      
      fifo_port.write(tr);
      @(posedge vif.clk);
    end
  endtask

endclass