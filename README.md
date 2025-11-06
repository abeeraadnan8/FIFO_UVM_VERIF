# FIFO_UVM_VERIF
This repository contains a SystemVerilog UVM-based verification environment for a parameterized FIFO (First-In First-Out) design. The environment is built to verify both functional correctness and corner-case behavior of the FIFO,
including:

Write and Read operations under normal conditions
Overflow (Write when FIFO is Full) handling
Underflow (Read when FIFO is Empty) handling
Continuous read/write transactions
Self-checking scoreboard with detailed transaction logging

The testbench follows UVM methodology, consisting of:

Driver, Monitor, Sequencer, and Sequence Items for stimulus generation

Scoreboard for data integrity checking

Environment and Test classes for test configuration and control
