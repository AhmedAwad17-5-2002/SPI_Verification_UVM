package RAM_pkg;

class RAM_Transaction;
parameter MEM_DEPTH=256;
parameter ADDR_SIZE=8;
 rand bit rst_n, rx_valid;
 rand bit [9:0] din;
  bit tx_valid;
 bit [ADDR_SIZE-1:0] dout;
 bit WRITE_SIG,READ_SIG; 
 rand bit WRITE,READ;


/*Constraints*/
constraint reset { rst_n dist {0:=5 , 1:=95};}
constraint RX_VALID { rx_valid dist {0:=20 , 1:=80}; }
constraint Din { 
if(WRITE)
	{
if(WRITE_SIG==1)
            din[9:8]==2'b01;
               else
               	din[9:8]==2'b00;
               }
               
               else if(READ)
               {
                 if(READ_SIG==0)
               din[9:8]==2'b10;
                else 
               din[9:8]==2'b11; 
                }

}

 /*Functional coverage */
covergroup RAM_cvr();

Dout:coverpoint dout;

Din:coverpoint din[9:8]{
bins Write_address= {2'b00};
bins Write_data={2'b01};
bins read_address={2'b10};
bins read_data={2'b11};

}

TX:coverpoint tx_valid
{ 
 bins Zero={0};
 bins ONE ={1};
}

TX_READ : cross TX, Din
{option.cross_auto_bin_max=0;
    bins tx_valid_din= binsof(Din.read_data) && binsof(TX.ONE); 
	}

	
endgroup

function  new();
RAM_cvr=new();	

endfunction 
    
       endclass	

        endpackage