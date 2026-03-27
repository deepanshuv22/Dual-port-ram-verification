class ram_sb;
   //Declare an event DONE
     event DONE;
    

   //Declare three variables of int datatype for counting
      
   //number of read data received from the reference model(rm_data_count)
   //number of read data received from the monitor(mon_data_count)
   //number of read data verified(data_verified)
      int rm_data_count;
      int mon_data_count;
      int data_verified;
   

   // Declare ram_trans handles as 'rm_data','rcvd_data' and cov_data 
      ram_trans rm_data, rcvd_data, cov_data;
   

   //Declare two mailboxes as 'rm2sb','rdmon2sb' parameterized by ram_trans 
     mailbox #(ram_trans) rm2sb;
     mailbox #(ram_trans) rdmon2sb;
         
   
   //Write the functional coverage model 
   //Define a covergroup as 'mem_coverage'   
   //Define coverpoints and bins for read, data_out and rd_address
   //Define cross for read,rd_address
      covergroup mem_coverage;
         option.per_instance = 1;
        READ: coverpoint cov_data.read {
         bins READ = {1};
				}
        DATA_OUT: coverpoint cov_data.data_out {
          bins zero = {0};
          bins low1 = {[1:500]};
          bins low2 = {[501:1000]};
          bins mid_low = {[1001:1500]};
          bins mid = {[1501:2000]};
          bins mid_high = {[2001:2500]};
          bins high1 = {[2501:3000]};
          bins high2 = {[3001:4293]};
          bins max = {4294};
}
        ADDRESS: coverpoint cov_data.rd_address {
         bins zero = {0};
         bins low1 = {[1:585]};
         bins low2 = {[586:1170]};
         bins mid_low = {[1171:1755]};
         bins mid = {[1756:2340]};
         bins mid_high = {[2341:2925]};
         bins high1 = {[2926:3510]};
         bins high2 = {[3511:4094]};
         bins max = {4095};}
         READ_CROSS_ADDRESS: cross READ,ADDRESS;


	endgroup
   
   
   //In constructor
   //pass the mailboxes as arguments
   //make the connections
      function new(mailbox #(ram_trans) rm2sb, mailbox #(ram_trans) rdmon2sb);
           this.rm2sb = rm2sb;
           this.rdmon2sb = rdmon2sb;
            mem_coverage = new();
	endfunction
   

   //In virtual task start    
   virtual task start();
           fork
              while(1) begin
               rm2sb.get(rm_data);
               rm_data_count++;
               rdmon2sb.get(rcvd_data);
               mon_data_count++;
               check(rcvd_data);


              end



           join_none
      
	  
	  
	  
	  
   endtask: start

   // Understand and include the virtual task check
   virtual task check(ram_trans rc_data);
      string diff;
      if(rc_data.read == 1) 
         begin
            if (rc_data.data_out == 0)
               $display("SB: Random data not written");
            else if(rc_data.read == 1 && rc_data.data_out != 0)
               begin
                  if(!rm_data.compare(rc_data,diff))
                     begin:failed_compare
                        rc_data.display("SB: Received Data");
                        rm_data.display("SB: Data sent to DUV");
                        $display("%s\n%m\n\n", diff);
                        $finish;
                     end:failed_compare
                  else
                     $display("SB:  %s\n%m\n\n", diff);
               end
            //shallow copy rm_data to cov_data
             cov_data = new rm_data;
            
            //Call the sample function on the covergroup 
                mem_coverage.sample();
            
              
            //Increment data_verified 
              data_verified++;
            
            //Trigger the event if the verified data count is equal to the sum of number of read and read-write transactions
             if(data_verified >= (number_of_transactions - rc_data.no_of_write_trans)) begin
                 ->DONE;
              end 
              end 
            
   endtask: check

   //In virtual function report 
   //display rm_data_count, mon_data_count, data_verified 
   virtual function void report();
      $display("-----------------SCOREBOARD REPORT-----------------\n");
      $display("%0d READ DATA GENERATED, %0d READ DATA RECEIVED,%0d READ DATA VERIFIED \n",rm_data_count,mon_data_count,data_verified);
      $display("----------------------------------\n");
      
   endfunction: report
    
endclass: ram_sb