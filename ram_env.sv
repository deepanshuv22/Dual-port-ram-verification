class ram_env;

   //Instantiate virtual interface with Write Driver modport,
   //Read Driver modport,Write monitor modport,Read monitor modport
     virtual ram_if.WR_DRV_MP wr_drv_if;
     virtual ram_if.RD_DRV_MP rd_drv_if;
     virtual ram_if.WR_MON_MP wr_mon_mp;
     virtual ram_if.RD_MON_MP rd_mon_mp;
      
     
   
 

   //Declare 6 mailboxes parameterized by ram_trans and construct it
     mailbox #(ram_trans) gen2wr_dr = new();
     mailbox #(ram_trans) gen2rd_dr = new();
     mailbox #(ram_trans) wr_mon2rm = new();
     mailbox #(ram_trans) rd_mon2rm = new();
     mailbox #(ram_trans) rm2sb = new();
     mailbox #(ram_trans) rd_mon2sb = new();
     
     
   
   //Create handle for ram_gen,ram_write_drv,ram_read_drv,ram_write_mon,
   //ram_read_mon,ram_model,ram_sb
    ram_gen gen;
    ram_write_drv write_drv;
    ram_read_drv read_drv;
    ram_write_mon write_mon;
    ram_read_mon read_mon;
   ram_model ref_model;
    ram_sb sb;


   //In constructor
   //pass the Driver and monitor interfaces as the argument
   //connect them with the virtual interfaces of ram_env
    function new( virtual ram_if.WR_DRV_MP wr_drv_if,
      virtual ram_if.RD_DRV_MP rd_drv_if,
      virtual ram_if.WR_MON_MP wr_mon_mp,
     virtual ram_if.RD_MON_MP rd_mon_mp
);
     this.wr_drv_if = wr_drv_if;
     this.rd_drv_if = rd_drv_if;
     this.wr_mon_mp = wr_mon_mp;
     this.rd_mon_mp = rd_mon_mp;

    endfunction
                                   
   //In virtual task build
   //create instances for generator,Write Driver,Read Driver,
   //Write monitor,Read monitor,Reference model,Scoreboard
     virtual task build();
       gen =new( gen2rd_dr,gen2wr_dr);
       write_drv = new(wr_drv_if,gen2wr_dr);
       read_drv = new(rd_drv_if,gen2rd_dr);
       write_mon = new(wr_mon_mp,wr_mon2rm);
       read_mon = new(rd_mon_mp,rd_mon2rm,rd_mon2sb);
       ref_model = new(wr_mon2rm,rd_mon2rm,rm2sb);
       sb = new(rm2sb,rd_mon2sb);
     endtask

   //Understand and include the virtual task reset_dut

   virtual task reset_dut();
      begin
         rd_drv_if.rd_drv_cb.rd_address<='0;
         rd_drv_if.rd_drv_cb.read<='0;

         wr_drv_if.wr_drv_cb.wr_address<=0;
         wr_drv_if.wr_drv_cb.write<='0;

         repeat(5) @(wr_drv_if.wr_drv_cb);
         for (int i=0; i<4096; i++)
            begin
               wr_drv_if.wr_drv_cb.write<='1;
               wr_drv_if.wr_drv_cb.wr_address<=i;
               wr_drv_if.wr_drv_cb.data_in<='0;
               @(wr_drv_if.wr_drv_cb);
            end
         wr_drv_if.wr_drv_cb.write<='0;
         repeat (5) @(wr_drv_if.wr_drv_cb);
      end
   endtask : reset_dut

   //In virtual task start
   //call the start methods of generator,Write Driver,Read Driver,
   //Write monitor,Read Monitor,reference model,scoreboard
    virtual task start();
       gen.start();
    write_drv.start();
    read_drv.start();
    write_mon.start();
    read_mon.start();
   ref_model.start();
    sb.start();
      

	endtask 

   virtual task stop();
      wait(sb.DONE.triggered);
   endtask : stop 

   //In virtual task run, call reset_dut, start, stop methods & report function from scoreboard
   virtual task run();
      reset_dut();
        start();
        stop();
        sb.report();

   endtask

endclass : ram_env