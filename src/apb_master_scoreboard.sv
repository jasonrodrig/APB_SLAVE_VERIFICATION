`uvm_analysis_imp_decl(_active_mon_scb)
`uvm_analysis_imp_decl(_passive_mon_scb)

class apb_master_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(apb_master_scoreboard)

  uvm_analysis_imp_active_mon_scb #(apb_master_sequence_item, apb_master_scoreboard) active_scb_port;
  uvm_analysis_imp_passive_mon_scb #(apb_master_sequence_item, apb_master_scoreboard) passive_scb_port;

  apb_master_sequence_item active_mon_packet_q[$];
  apb_master_sequence_item passive_mon_packet_q[$];

//memory declaration
//  bit [7:0] mem [511:0];

  static int pass_count;
  static int fail_count;

  function new(string name = "apb_master_scoreboard", uvm_component parent);
    super.new(name,parent);
  endfunction: new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    active_scb_port = new("active_scb_port",this);
    passive_scb_port = new("passive_scb_port",this);
  endfunction: build_phase

  function void write_active_mon_scb(apb_master_sequence_item pkt);
    `uvm_info(get_type_name(), "Received input packet ", UVM_DEBUG)
    active_mon_packet_q.push_back(pkt);
  endfunction: write_active_mon_scb

  function void write_passive_mon_scb(apb_master_sequence_item pkt);
    `uvm_info(get_type_name(), "Received output packet ", UVM_DEBUG)
    passive_mon_packet_q.push_back(pkt);
  endfunction: write_passive_mon_scb

  virtual task run_phase(uvm_phase phase);
    apb_master_sequence_item act_item;
    apb_master_sequence_item pass_item;

    forever begin
      fork
        begin
          wait(active_mon_packet_q.size()>0);
          act_item  = active_mon_packet_q.pop_front();
        end
        begin
          wait(passive_mon_packet_q.size()>0);
          pass_item = passive_mon_packet_q.pop_front();
        end
      join
    // comparison logic
    end
  endtask: run_phase

  function void extract_phase(uvm_phase phase);
    super.extract_phase(phase);
    $display("");
    `uvm_info("SCB", $sformatf("TOTAL PASS : %0d", pass_count), UVM_NONE)
    `uvm_info("SCB", $sformatf("TOTAL FAIL : %0d", fail_count), UVM_NONE)
    `uvm_info("SCB", $sformatf("TOTAL CASES : %0d", fail_count+pass_count), UVM_NONE)
    $display("");
  endfunction: extract_phase
endclass: apb_master_scoreboard
