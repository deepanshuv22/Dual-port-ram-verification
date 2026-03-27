class ram_trans;

   // Declare the following rand fields
      
   // data (bit/logic type , size 64)
         rand bit [63:0] data;
      
   // rd_address, wr_address (bit/logic type , size 12)
       rand bit [11:0] rd_address, wr_address;
       
      
   // read, write (bit/logic type , size 1)
        rand bit read, write;

   // Declare a variable data_out (logic type , size 64)
         logic [63:0] data_out;
         
      
   // Declare a static variable trans_id (int type), to keep the count of transactions generated
        static int trans_id;
      
   // Declare three static variables no_of_read_trans, no_of_write_trans, no_of_RW_trans (int type)
       static int no_of_read_trans, no_of_write_trans, no_of_RW_trans;


   // Add the following constraints 
   // wr_address!=rd_address;
     constraint address {wr_address!=rd_address;}
         
   // read,write != 2'b00;
    constraint read_write {{read,write}!=2'b00;}
         
   // data between 1 and 4294 
      constraint data_limit {data inside {[1:4294]};}  

   
   //In virtual function display 
   // display the string         
   // display all the properties of the transaction class
        virtual function void display(input string my_string = "");
          $display("Class Transaction %s",$sformatf("data:%0d rd_address:%0d wr_address:%0d read:%0d write :%0d data_out:%0d trans_id:%0d no_of_read_trans:%0d no_of_write_trans:%0d,no_of_RW_trans:%0d",data,rd_address,wr_address,read,write,data_out,trans_id,no_of_read_trans,no_of_write_trans,no_of_RW_trans));
        endfunction


   // In post_randomize method
      function void post_randomize();
      // Increment trans_id
        trans_id++ ;
         
      // If it is only read transaction, increment no_of_read_trans
       if(read && !write) no_of_read_trans++;
      
         
         
      // If it is only write transaction, increment no_of_write_trans
       if(!read && write) no_of_write_trans++;
   
      // If it is read-write transaction, increment no_of_RW_trans
       if(read && write) no_of_RW_trans++;
         
      // call the display method and pass a string
         this.display("POST_RANDOMIZATION");
endfunction
virtual function void display(string my_string = "");
  $display("Class Transaction %s data:%0d rd_address:%0d wr_address:%0d read:%0b write:%0b data_out:%0d trans_id:%0d R:%0d W:%0d RW:%0d",
           my_string, data, rd_address, wr_address, read, write, data_out,
           trans_id, no_of_read_trans, no_of_write_trans, no_of_RW_trans);
endfunction

endclass