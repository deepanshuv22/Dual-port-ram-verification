package ram_pkg;

   int number_of_transactions = 1;
  
   //include the files 
   `include "ram_trans.sv"
   `include "ram_gen.sv"
   `include "ram_write_drv.sv"
   `include "ram_read_drv.sv"
   `include "ram_write_mon.sv"
   `include "ram_read_mon.sv"
   `include "ram_model.sv"
   `include "ram_sb.sv"
   `include "ram_env.sv"
   `include "test.sv" 

endpackage