class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)

  // --------------------------
  // Analysis port from monitor
  // --------------------------
  uvm_analysis_imp#(sequence_item, scoreboard) scb_port;

  // --------------------------
  // Queue for incoming transactions
  // --------------------------
  sequence_item exp_queue[$];
  sequence_item expdata;

  // --------------------------
  // Counters for summary
  // --------------------------
  int unsigned read_match_count;
  int unsigned read_mismatch_count;
  int unsigned write_match_count;
  int unsigned write_mismatch_count;

  // --------------------------
  // Constructor
  // --------------------------
  function new(string name = "scoreboard", uvm_component parent = null);
    super.new(name, parent);
    scb_port = new("scb_port", this);
  endfunction

  // --------------------------
  // Build Phase
  // --------------------------
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    read_match_count     = 0;
    read_mismatch_count  = 0;
    write_match_count    = 0;
    write_mismatch_count = 0;
  endfunction

  // --------------------------
  // Write: Called automatically
  // when monitor sends a transaction
  // --------------------------
  function void write(sequence_item tr);
    // store a copy (if sequence_item is class-type you may want to clone)
    exp_queue.push_back(tr);
  endfunction

  // --------------------------
  // Run Phase
  // --------------------------
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    `uvm_info(get_type_name(), "Scoreboard Started", UVM_LOW)

    forever begin
      // wait until there is at least one transaction
      wait (exp_queue.size() > 0);
      expdata = exp_queue.pop_front();

      // ------------------------------------------------------
      // WRITE Transaction
      // ------------------------------------------------------
      if (expdata.wr_en) begin
        // check valid data (avoid X/Z)
        if (^expdata.datain !== 1'bx && ^expdata.datain !== 1'bz) begin
          // if FIFO wasn't full when the write was attempted, treat as match
          if (!expdata.full) begin
            write_match_count++;
            `uvm_info("FIFO_WRITE_SUCCESSFUL",
                      $sformatf("WRITE_EN=%0b DATA_IN=0x%0h (FIFO not full)",
                                expdata.wr_en, expdata.datain),
                      UVM_MEDIUM)
          end
          // write attempted while FIFO full -> overflow attempt
          else begin
            write_match_count++;
            `uvm_info("FIFO_WRITE_ON_FULL",
                      $sformatf("WRITE_EN=%0b DATA_IN=0x%0h (FIFO full)",
                                expdata.wr_en, expdata.datain),
                      UVM_MEDIUM)
          end
        end
        else begin
          // uninitialized or Z data being written
          write_mismatch_count++;
          `uvm_info("FIFO_WRITE_UNINIT_OR_Z",
                    $sformatf("WRITE_EN=%0b DATA_IN=0x%0h (X/Z detected)",
                              expdata.wr_en, expdata.datain),
                    UVM_MEDIUM)
        end
      end // end write branch

      // ------------------------------------------------------
      // READ Transaction
      // ------------------------------------------------------
      else if (expdata.rd_en) begin
        // datain presence is optional for read validation; check dataout specifically
        if (^expdata.dataout !== 1'bx && ^expdata.dataout !== 1'bz) begin
          // read valid and FIFO not empty -> match
          if (!expdata.empty) begin
            read_match_count++;
            `uvm_info("FIFO_READ_SUCCESSFUL",
                      $sformatf("READ_EN=%0b DATA_IN=0x%0h DATA_OUT=0x%0h (FIFO not empty)",
                                expdata.rd_en, expdata.datain, expdata.dataout),
                      UVM_MEDIUM)
          end
          // read attempted while FIFO empty -> underflow attempt 
          else begin
            //dataout does not update (it holds its previous value).
            //rd_ptr does not increment.
            //counter does not change
            read_match_count++;
            `uvm_info("FIFO_READ_ON_EMPTY_BUFFER",
                      $sformatf("READ_EN=%0b DATA_IN=0x%0h DATA_OUT REMAINS=0x%0h (FIFO empty)",
                                expdata.rd_en, expdata.datain, expdata.dataout),
                      UVM_MEDIUM)
          end
        end
        else begin
          // uninitialized or Z data read
          read_mismatch_count++;
          `uvm_info("FIFO_READ_UNINIT_OR_Z",
                    $sformatf("READ_EN=%0b DATA_IN=0x%0h DATA_OUT=0x%0h (X/Z detected)",
                              expdata.rd_en, expdata.datain, expdata.dataout),
                    UVM_MEDIUM)
        end
      end // end read branch

      // ------------------------------------------------------
      // Neither read nor write asserted: unexpected transaction
      // ------------------------------------------------------
      else begin
        `uvm_warning("SCOREBOARD_INVALID_TR",
                     $sformatf("Received transaction with no rd_en/wr_en set: wr_en=%0b rd_en=%0b",
                               expdata.wr_en, expdata.rd_en))
      end
    end // forever
  endtask

  // -----------------------------------------------------------------
  // Final Phase Summary
  // -----------------------------------------------------------------
  function void final_phase(uvm_phase phase);
    super.final_phase(phase);
    `uvm_info("SCOREBOARD_SUMMARY",
              $sformatf("Total Matches: %0d | Total Mismatches: %0d\nRead Matches: %0d | Read Mismatches: %0d\nWrite Matches: %0d | Write Mismatches: %0d",
                        (read_match_count + write_match_count),
                        (read_mismatch_count + write_mismatch_count),
                        read_match_count, read_mismatch_count,
                        write_match_count, write_mismatch_count),
              UVM_NONE)
  endfunction

endclass : scoreboard
