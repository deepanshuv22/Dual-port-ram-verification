class ram_read_mon;

   //Instantiate virtual interface instance rd_mon_if of type ram_if with RD_MON_MP modport
     virtual ram_if.RD_MON_MP rd_mon_if;
	

   //Declare three handles 'rddata', 'data2rm' and 'data2sb' of class type ram_trans
      ram_trans rddata,data2rm,data2sb;
	

   //Declare two mailboxes 'mon2rm' and 'mon2sb' parameterized by type ram_trans
      mailbox #(ram_trans) mon2rm,mon2sb;
	
	
	
   //In constructor
   //Pass the following as the input arguments 	
   //virtual interface 
   //mailbox handles 'mon2rm' and 'mon2sb' parameterized by ram_trans	
   //make the connections and allocate memory for 'rddata'
    function new(virtual ram_if.RD_MON_MP rd_mon_if, mailbox #(ram_trans) mon2rm ,mailbox #(ram_trans) mon2sb);
    this.rd_mon_if = rd_mon_if;
    this.mon2rm = mon2rm;
    this.mon2sb = mon2sb;
    this.rddata = new;

     endfunction

   virtual task monitor();
	   @(rd_mon_if.rd_mon_cb);
	   wait (rd_mon_if.rd_mon_cb.read==1);
      @(rd_mon_if.rd_mon_cb);
	   begin
		   rddata.read       = rd_mon_if.rd_mon_cb.read;
		   rddata.rd_address = rd_mon_if.rd_mon_cb.rd_address;
		   rddata.data_out   = rd_mon_if.rd_mon_cb.data_out;
		   //call the display of the ram_trans to display the monitor data
		   rddata.display("DATA FROM READ MONITOR");
		
      end
   endtask: monitor
	
   //In virtual task start			
   virtual task start();
	   //Within fork-join_none
	   //In forever loop
			
	   //Call the monitor task
	   //Understand the provided monitor task 
	   //Monitor task samples the interface signals 
	   //according to the protocol and convert to transaction items 
						
	   //Shallow copy rddata to data2sb;
	   //Shallow copy rddata to data2rm;
						
	   //Put the transaction item into two mailboxes mon2rm and mon2sb
          fork
          forever begin
            monitor();
             data2sb = new rddata;
             data2rm = new rddata;
             mon2rm.put(data2rm);
             mon2sb.put(data2sb);
            
           
           end


          join_none
					
				
   endtask: start

endclass:ram_read_mon