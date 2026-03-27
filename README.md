Dual Port RAM SystemVerilog Verification Environment
Overview
This repository contains a complete, layered SystemVerilog verification environment built to verify the functionality of a Dual Port RAM. The testbench architecture mimics industry-standard UVM methodologies, utilizing Object-Oriented Programming (OOP) to create highly modular, reusable, and scalable verification components.

Verification Architecture
The environment is structured into distinct, decoupled transactors communicating via SystemVerilog mailboxes:

Transaction: Defines the core data packet (ram_trans) with constrained random fields for data, read/write addresses, and operation types.

Generator: Creates randomized stimulus and pushes transactions to the respective drivers.

Drivers (Read & Write): Specialized components that receive transactions and drive the pin-level signals on the virtual interface according to the memory protocol.

Monitors (Read & Write): Passively sample the virtual interface and broadcast observed transactions to the Scoreboard and Reference Model.

Reference Model: Acts as the golden predictor. It utilizes a SystemVerilog associative array to securely store expected memory states based on write operations, generating expected read data on the fly.

Scoreboard: The automated checking mechanism. It compares the actual data received from the Read Monitor against the expected data from the Reference Model, reporting passes and failures.

Coverage (Subscriber): Implements a covergroup with specific coverpoints and cross coverage to ensure all addresses and operation types are thoroughly exercised during simulation.

Key SystemVerilog Features Demonstrated
Deep vs. Shallow Copying of objects.

Inter-Process Communication (IPC) using Mailboxes and Semaphores.

Thread control using fork...join, join_any, and join_none.

Polymorphism and Virtual Methods for test case extensions.

Clocking blocks and Modports within the interface to prevent race conditions.
