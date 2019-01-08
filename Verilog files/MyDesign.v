//---------------------------------------------------------------------------
//---------------------------------------------------------------------------
// DUT


`define MSG_LENGTH 5

//Top module
module MyDesign #(parameter OUTPUT_LENGTH       = 8,
                  parameter MAX_MESSAGE_LENGTH  = 55,
                  parameter NUMBER_OF_Ks        = 64,
                  parameter NUMBER_OF_Hs        = 8 ,
                  parameter SYMBOL_WIDTH        = 8, 
		  parameter DATA_WIDTH1	      = 32,
		  parameter DATA_WIDTH	      = 8 )
            (

            //---------------------------------------------------------------------------
            // Control
            //
            output reg                                   dut__xxx__finish     ,
            input  wire                                  xxx__dut__go         ,  
            input  wire  [ $clog2(MAX_MESSAGE_LENGTH):0] xxx__dut__msg_length ,

            //---------------------------------------------------------------------------
            // Message memory interface
            //
            output reg  [ $clog2(MAX_MESSAGE_LENGTH)-1:0]   dut__msg__address  ,  // address of letter
            output reg                                      dut__msg__enable   ,
            output reg                                      dut__msg__write    ,
            input  wire [7:0]                               msg__dut__data     ,  // read each letter
            
            //---------------------------------------------------------------------------
            // K memory interface
            //
            output reg  [ $clog2(NUMBER_OF_Ks)-1:0]     dut__kmem__address  ,
            output reg                                  dut__kmem__enable   ,
            output reg                                  dut__kmem__write    ,
            input  wire [31:0]                          kmem__dut__data     ,  // read data

            //---------------------------------------------------------------------------
            // H memory interface
            //
            output reg  [ $clog2(NUMBER_OF_Hs)-1:0]     dut__hmem__address  ,
            output reg                                  dut__hmem__enable   ,
            output reg                                  dut__hmem__write    ,
            input  wire [31:0]                          hmem__dut__data     ,  // read data


            //---------------------------------------------------------------------------
            // Output data memory 
            //
            output reg  [ $clog2(OUTPUT_LENGTH)-1:0]    dut__dom__address  ,
            output reg  [31:0]                          dut__dom__data     ,  // write data
            output reg                                  dut__dom__enable   ,
            output reg                                  dut__dom__write    ,


            //-------------------------------
            // General
            //
            input  wire                 clk             ,
            input  wire                 reset  

            );

  //---------------------------------------------------------------------------
  //
  //<<<<----  YOUR CODE HERE    ---->>>>

  //`include "v564.vh"

wire [DATA_WIDTH-1:0] data_out;
wire [DATA_WIDTH1-1:0] data1;
wire [DATA_WIDTH1-1:0] data2;
wire [DATA_WIDTH1-1:0] Hash_out;
wire [31:0] H_out;
wire [31:0] K_out;
wire [31:0] W_out;
wire [5:0] count_hout;
wire [6:0] count_h;
wire [6:0] count_in;
wire [6:0] write_h;
wire [31:0] Hash_final;
wire reset_address_gen;
wire start_message_counter;
wire start_address_gen;
wire start_address_gen_write;
wire reset_address_gen_write;
wire reset_wgenerate_counters;
wire reset_counter;
wire [ $clog2(MAX_MESSAGE_LENGTH)-1:0] EndAddress_message;
wire [ $clog2(NUMBER_OF_Ks)-1:0] EndAddress_K;
wire [ $clog2(NUMBER_OF_Hs)-1:0] EndAddress_H;
wire [ $clog2(OUTPUT_LENGTH)-1:0] EndAddress_O;
wire [ $clog2(MAX_MESSAGE_LENGTH):0] internal_msg_length;
wire [5:0] count;
wire int_reset;
wire internal_finish;
wire kmem__write;
wire hmem__write;
wire msg__write;
wire dom__write;

Controller #(.MAX_MESSAGE_LENGTH(MAX_MESSAGE_LENGTH),.NUMBER_OF_Ks(NUMBER_OF_Ks),.NUMBER_OF_Hs(NUMBER_OF_Hs),.OUTPUT_LENGTH(OUTPUT_LENGTH)) controller (.clk(clk),.reset(reset),.int_reset(int_reset),.dut__xxx__finish(dut__xxx__finish),.xxx__dut__go(xxx__dut__go),.xxx__dut__msg_length(xxx__dut__msg_length),.internal_msg_length(internal_msg_length),.internal_finish(internal_finish),.EndAddress_message(EndAddress_message),.EndAddress_K(EndAddress_K),.EndAddress_H(EndAddress_H),.EndAddress_O(EndAddress_O),.reset_address_gen(reset_address_gen),.start_address_gen(start_address_gen),.reset_counter(reset_counter),.reset_wgenerate_counters(reset_wgenerate_counters),.start_message_counter(start_message_counter),.reset_address_gen_write(reset_address_gen_write),
.start_address_gen_write(start_address_gen_write),.count(count),.write_h(write_h),.dut__dom__write(dut__dom__write),.dut__hmem__write(dut__hmem__write),.dut__kmem__write(dut__kmem__write),.dut__msg__write(dut__msg__write),.kmem__write(kmem__write),.dom__write(dom__write),.hmem__write(hmem__write),.msg__write(msg__write));
Memory_Interface_message message_mem(.clk(clk),.reset(int_reset),.start1(reset_address_gen),.start2(start_address_gen),.EndAddress(EndAddress_message),.address(dut__msg__address),.enable(dut__msg__enable),.data_in(msg__dut__data),.data_out(data_out));
Memory_Interface_K K_mem(.clk(clk),.reset(int_reset),.start1(reset_address_gen),.start2(start_address_gen),.EndAddress(EndAddress_K),.enable(dut__kmem__enable),.address(dut__kmem__address),.data_in(kmem__dut__data),.data_out(data1));
Memory_Interface_H H_mem(.clk(clk),.reset(int_reset),.start1(reset_address_gen),.start2(start_address_gen),.EndAddress(EndAddress_H),.enable(dut__hmem__enable),.address(dut__hmem__address),.data_in(hmem__dut__data),.data_out(data2));
Memory_Interface_O output_mem(.clk(clk),.reset(int_reset),.start1(reset_address_gen_write),.start2(start_address_gen_write),.EndAddress(EndAddress_O),.address(dut__dom__address),.enable(dut__dom__enable),.data_in(Hash_out),.data_out(dut__dom__data));
Warray w_vector(.clk(clk),.reset(int_reset),.start(start_message_counter),.start1(reset_wgenerate_counters),.message(data_out),.message_length(internal_msg_length),.row_select(count_hout),.W_out(W_out),.count(count),.msg__write(msg__write));
hk_storage hk_storage(.clk(clk),.reset(int_reset),.data1(data1),.data2(data2),.start1(reset_counter),.H_out(H_out),.K_out(K_out),.row_select(count_hout),.count_h(count_h),.Hash_final(Hash_final),.count_in(count_in),.Hash_out(Hash_out),.internal_finish(internal_finish),.dom__write(dom__write),.write_h(write_h),.hmem__write(hmem__write),.kmem__write(kmem__write));
Computation compute_block(.clk(clk),.reset(int_reset),.K_out(K_out),.W_out(W_out),.count_h1(count_h),.count_h2(count_hout),.H_out(H_out),.start1(reset_address_gen),.Hash_final(Hash_final),.count_in(count_in));
 
  // 
  //---------------------------------------------------------------------------

endmodule

//Controller module
module Controller #(parameter MAX_MESSAGE_LENGTH  = 55,parameter NUMBER_OF_Ks        = 64,
                  parameter NUMBER_OF_Hs        = 8 ,parameter OUTPUT_LENGTH       = 8 )
				  (clk,reset,int_reset,dut__xxx__finish,xxx__dut__go,xxx__dut__msg_length,internal_msg_length,internal_finish,EndAddress_message,EndAddress_K,EndAddress_H,EndAddress_O,reset_address_gen,start_address_gen,reset_counter,reset_wgenerate_counters,start_message_counter,reset_address_gen_write,start_address_gen_write,count,write_h,kmem__write,dom__write,msg__write,hmem__write,dut__dom__write,dut__hmem__write,dut__kmem__write,dut__msg__write);
input clk,reset;
output dut__xxx__finish;
output int_reset;
input xxx__dut__go;
input internal_finish;
input [5:0] count;
input [ $clog2(MAX_MESSAGE_LENGTH):0] xxx__dut__msg_length;
output [ $clog2(MAX_MESSAGE_LENGTH):0] internal_msg_length;
output [ $clog2(MAX_MESSAGE_LENGTH)-1:0] EndAddress_message;
output [ $clog2(NUMBER_OF_Ks)-1:0] EndAddress_K;
output [ $clog2(NUMBER_OF_Hs)-1:0] EndAddress_H;
output [ $clog2(OUTPUT_LENGTH)-1:0] EndAddress_O;
output reset_address_gen;
output start_address_gen;
output reset_address_gen_write;
output start_address_gen_write;
output reset_counter;
output reset_wgenerate_counters;
output start_message_counter;
output dut__dom__write;
output dut__hmem__write;
output dut__kmem__write;
output dut__msg__write;
input kmem__write;
input hmem__write;
input dom__write;
input msg__write;
input [6:0] write_h;
reg [ $clog2(MAX_MESSAGE_LENGTH):0] internal_msg_length;
reg [ $clog2(MAX_MESSAGE_LENGTH)-1:0] EndAddress_message;
reg [ $clog2(NUMBER_OF_Ks)-1:0] EndAddress_K;
reg [ $clog2(NUMBER_OF_Hs)-1:0] EndAddress_H;
reg [ $clog2(OUTPUT_LENGTH)-1:0] EndAddress_O;
reg reset_address_gen;
reg start_address_gen;
reg reset_address_gen_write;
reg start_address_gen_write;
reg reset_counter;
reg reset_wgenerate_counters;
reg start_message_counter;
reg [2:0] counter;
reg internal_go;
reg dut__xxx__finish;
reg int_reset;
reg dut__dom__write;
reg dut__hmem__write;
reg dut__kmem__write;
reg dut__msg__write;
reg flag;
always@(posedge clk)
if (reset)
begin
	internal_msg_length<=0;
	EndAddress_message<=0;
	EndAddress_K<=0;
	EndAddress_H<=0;
	EndAddress_O<=0;
end
else
begin 
	internal_msg_length<=xxx__dut__msg_length;							//Generating an internal message signal
	EndAddress_message<=(internal_msg_length-1'h1);						//Generating end addresses for accessing H,K,message and output memory 
	EndAddress_K<=6'h3f;
	EndAddress_H<=6'h7;
	EndAddress_O<=6'h7;
end
always@(posedge clk)													//flag to prevent go signal to interrupt the design before finishing computation
if (reset)
	flag<=0;
else if (xxx__dut__go)
	flag<=1'b1;
else if (dut__xxx__finish)
	flag<=0;
always@(posedge clk)													//Generating internal reset signal
if (reset)
	int_reset<=reset;
else if (xxx__dut__go && (!flag))
	int_reset<=xxx__dut__go;
else 
	int_reset<=0;
always@(posedge clk)													//Generating internal go signal
if (reset)
	internal_go<=0;
else if(xxx__dut__go==1'b1 && (!flag))
	internal_go<=xxx__dut__go;
else if (flag)
	internal_go<=internal_go;
	
always@(posedge clk)													//Counter controller to generate signals to differnt modules
if (reset)
	counter<=3'b0;
else if(xxx__dut__go==1'b1 && (!flag))
	counter<=3'b0;
else if ((counter<3'b011 && internal_go==1'b1) || (counter!=3'b101 && write_h<7'ha && write_h>7'h0))
	counter<=counter+1'b1;
always@(posedge clk)
if (reset)
begin
	start_address_gen<=0;
	reset_address_gen<=0;
	reset_counter<=0;
	start_message_counter<=0;
	reset_wgenerate_counters<=0;
	start_address_gen_write<=0;
	reset_address_gen_write<=0;	
end
else if (internal_go==1'b1)
begin
	case (counter)
	3'b000:  reset_address_gen<=1'b1;									//Signal to reset address generating counter
	3'b001:  begin
			start_address_gen<=1'b1;									//Signal to start address generating counter
			reset_address_gen<=1'b0;
			reset_counter<=1'b1;										//Signal to reset counters in all modules
		end
	3'b010:  begin
			reset_wgenerate_counters<=1'b1;								//Signal to reset counter generating W vector
			reset_counter<=1'b0;
			start_message_counter<=1'b1;								//Signal to start counter to read in message 
		end	
	3'b011:  reset_wgenerate_counters<=1'b0;	
	3'b100:	 reset_address_gen_write<=1'b1;								//Signal to reset counter to generate address for output memory
	3'b101: begin 
			start_address_gen_write<=1'b1;								//Signal to start counter to generate address for output memory
			reset_address_gen_write<=1'b0;
			if (count==((internal_msg_length)+1))
				start_message_counter<=0;
			end
	endcase
end
always@(posedge clk)													//Generating finish signal based on internal finish signal
if (reset)
	dut__xxx__finish<=0;
else if( xxx__dut__go==1'b1 && (!flag))
	dut__xxx__finish<=0;
else if (int_reset)
	dut__xxx__finish<=0;
else if (internal_finish==1'b1)
	dut__xxx__finish<=1'b1;
always@(posedge clk)													//Generating write signals for memories 
if (reset)
begin
	dut__msg__write<=0;
	dut__kmem__write<=0;
	dut__hmem__write<=0;
	dut__dom__write<=0;
end
else
begin 
	dut__msg__write<=msg__write;
	dut__kmem__write<=kmem__write;
	dut__hmem__write<=hmem__write;
	dut__dom__write<=dom__write;
end
endmodule
  
//Memory interface module for H 
module Memory_Interface_H (clk,reset,start1,start2,EndAddress,enable,address,data_in,data_out);
parameter NUMBER_OF_Hs= 8;
parameter  ADDR_WIDTH= $clog2(NUMBER_OF_Hs );
parameter  DATA_WIDTH= 32;
input reset,clk;
input [ADDR_WIDTH-1:0]   EndAddress;
input [DATA_WIDTH-1:0]data_in;
input start1,start2;
output enable;
output [DATA_WIDTH-1:0] data_out;
output [ADDR_WIDTH-1:0] address;
reg [ADDR_WIDTH-1:0] address;
reg [DATA_WIDTH-1:0] data_out;
wire complete;
reg enable;
assign complete=(address==EndAddress);							//Checking if the address has reached end address

always@(posedge clk)											//Counter generating address for reading from H memory
if (reset)
	begin
		address<=6'h0;
		enable<=0;
	end
else if (start1)
	begin
		address<=6'h0;
		enable<=1;
	end
else if (!complete && start2)
	begin
		address<=address+1'b1;
	end
else if (complete)
		enable<=0;
		
	
always@(posedge clk)											//Reading in and storing data read from memory
if (reset)
	data_out<=32'b0;
else 
	data_out<=data_in;
endmodule

module Memory_Interface_K (clk,reset,start1,start2,EndAddress,enable,address,data_in,data_out);
parameter NUMBER_OF_Ks= 64;
parameter  ADDR_WIDTH= $clog2(NUMBER_OF_Ks );
parameter  DATA_WIDTH= 32;
input reset,clk;
input [ADDR_WIDTH-1:0]   EndAddress;
input [DATA_WIDTH-1:0]data_in;
input start1,start2;
output enable;
output [DATA_WIDTH-1:0] data_out;
output [ADDR_WIDTH-1:0] address;
reg [ADDR_WIDTH-1:0] address;
reg [DATA_WIDTH-1:0] data_out;
wire complete;
reg enable;
assign complete=(address==EndAddress);							//Checking if the address has reached end address

always@(posedge clk)											//Counter generating address for reading from K memory
if (reset)
	begin
		address<=6'h0;
		enable<=0;
	end
else if (start1)
	begin
		address<=6'h0;
		enable<=1;
	end
else if (!complete && start2)
	begin
		address<=address+1'b1;
	end
else if (complete)
		enable<=0;
		
	
always@(posedge clk)											//Reading in and storing data read from memory
if (reset)
	data_out<=32'b0;
else 
	data_out<=data_in;
endmodule

module Memory_Interface_message (clk,reset,start1,start2,EndAddress,enable,address,data_in,data_out);
parameter MAX_MESSAGE_LENGTH  = 55;
parameter  ADDR_WIDTH= $clog2(MAX_MESSAGE_LENGTH);
parameter  DATA_WIDTH= 8;
input reset,clk;
input [ADDR_WIDTH-1:0]   EndAddress;
input [DATA_WIDTH-1:0]data_in;
input start1,start2;
output enable;
output [DATA_WIDTH-1:0] data_out;
output [ADDR_WIDTH-1:0] address;
reg [ADDR_WIDTH-1:0] address;
reg [DATA_WIDTH-1:0] data_out;
wire complete;
reg enable;
assign complete=(address==EndAddress);							//Checking if the address has reached end address

always@(posedge clk)											//Counter generating address for reading from message memory
if (reset)
	begin
		address<=6'h0;
		enable<=0;
	end
else if (start1)
	begin
		address<=6'h0;
		enable<=1;
	end
else if (!complete && start2)
	begin
		address<=address+1'b1;
	end
else if (complete)
		enable<=0;
		
	
always@(posedge clk)											//Reading in and storing data read from memory
if (reset)
	data_out<=32'b0;
else 
	data_out<=data_in;
endmodule

module Memory_Interface_O (clk,reset,start1,start2,EndAddress,enable,address,data_in,data_out);
parameter OUTPUT_LENGTH= 8;
parameter  ADDR_WIDTH= $clog2(OUTPUT_LENGTH);
parameter  DATA_WIDTH= 32;
input reset,clk;
input [ADDR_WIDTH-1:0]   EndAddress;
input [DATA_WIDTH-1:0]data_in;
input start1,start2;
output enable;
output [DATA_WIDTH-1:0] data_out;
output [ADDR_WIDTH-1:0] address;
reg [ADDR_WIDTH-1:0] address;
reg [DATA_WIDTH-1:0] data_out;
wire complete;
reg enable;
assign complete=(address==EndAddress);						//Checking if the address has reached end address

always@(posedge clk)										//Counter generating address for writing to output memory
if (reset)
	begin
		address<=6'h0;
		enable<=0;
	end
else if (start1)
	begin
		address<=6'h0;
		enable<=1;
	end
else if (!complete && start2)
	begin
		address<=address+1'b1;
	end
else if (complete)
		enable<=0;
		
	
always@(posedge clk)										//Writing data to output memory
if (reset)
	data_out<=32'b0;
else 
	data_out<=data_in;
endmodule

//Warray module to read in message and generate W array
module Warray(clk,reset,start,start1,message,message_length,row_select,W_out,count,msg__write);
parameter a = 8'b10000000;
parameter MAX_MESSAGE_LENGTH  = 55;
integer i,j,z;
input clk,reset,start,start1;
input [7:0] message;
input [ $clog2(MAX_MESSAGE_LENGTH):0] message_length;
output [5:0] row_select;
output [31:0] W_out; 
output [5:0] count;
output msg__write;
reg [5:0] count;
reg [1:0] column_select;
reg [5:0] row_select;
reg [7:0] data_in;
reg [31:0] W[63:0];
reg [6:0] count_wout;
reg [31:0] W_out;
wire [8:0] length;
reg msg__write;
assign length=(message_length<<3);							//Converting the message length into binary
always@(posedge clk)										//Counter to read in message from message memory
begin
if (reset )
begin
	count<=0;
	msg__write<=1'b0;										//write signal to message memory set to 0
end
else if (start && count!=(message_length+1))
begin
	count<=count+1'b1;
	msg__write<=1'b0;	
end
end	
always@(posedge clk)										//Reading and storing message from message memory
begin
if (reset)
begin
	data_in<=0;
end
else if (count==message_length)
	data_in<=a;
else if (start && count!=(message_length+1))
	data_in<=message;
else if (count==(message_length+1))
begin
	data_in<=0;	
end
end
always@(posedge clk)										//Column decoder for storing message in W array
if (reset)
	column_select<=0;
else if(start1)
	column_select<=0;
else
	column_select<=column_select+1'b1;
always@(posedge clk)										//Row decoder for storing message in W array
if (reset)
	row_select<=0;
else if (start1)
	row_select<=0;
else if (column_select==2'b11 && row_select!=6'he ) 
	row_select<=row_select+1'b1;
always@(posedge clk)										//Creating W array
if (reset)
begin
for (i=0;i<64;i=i+1)begin
	W[i]<=0;
end
end
else if (row_select==6'he)									//Creating W[16]-W[64]
begin
	for(j=0;j<16;j=j+1)
	begin
	W[z]<=W[z];
	end
	for(j=16;j<64;j=j+1)
	begin
		W[j]<=((({W[j-2],W[j-2]}>>17)^({W[j-2],W[j-2]}>>19))^(W[j-2]>>10))+W[j-7]+W[j-16]+((({W[j-15],W[j-15]}>>7)^({W[j-15],W[j-15]}>>18))^(W[j-15]>>3));
	end
end
else														//Filling in message to create W[0]-W[15]
begin
	case(column_select)
		2'b00:if(reset)
			W[row_select][31:24]<=0;
		      else
			begin
			W[row_select][31:24]<=data_in;
			end
		2'b01:if(reset)
			W[row_select][23:16]<=0;
		      else
			W[row_select][23:16]<=data_in;
		2'b10:if(reset)
			W[row_select][15:8]<=0;
		      else
			W[row_select][15:8]<=data_in;
		2'b11:if(reset)
			W[row_select][7:0]<=0;
		      else
			W[row_select][7:0]<=data_in;
	endcase
	W[15][7:0]<=length[7:0];								//Appending 1 to the end after filling in message
	W[15][15:8]<={{7{1'b0}},length[8]};
end
always@(posedge clk)										//Counter to output elements of W array for computation
if (reset)
	count_wout<=6'h0;
else if(start1)
	count_wout<=6'h0;
else if (row_select==6'he && count_wout!=7'h40)
	count_wout<=count_wout+1'b1;
always@(posedge clk)										//Outputting elements of W array
if (reset)
	W_out<=0;
else if (row_select!=6'he)
	W_out<=0;
else if (count_wout!=7'h40)
	W_out<=W[count_wout];
endmodule

//Module for performing 64 iterations on a-h registers
module Computation(clk,reset,K_out,W_out,count_h1,count_h2,H_out,start1,Hash_final,count_in);
integer i;
input clk,reset,start1;
input [31:0] K_out;
input [31:0] W_out;
input [31:0] H_out;
input [6:0] count_h1;
input [5:0] count_h2;
output [31:0] Hash_final;
output [6:0] count_in;
reg [31:0] H[7:0];
reg [6:0] count_h;
reg [6:0] count_in;
reg [6:0] h_index;
reg [31:0] K;
reg [31:0] W;
reg [31:0] Hash_final;
wire [31:0] Ch;
wire [31:0] Maj;
wire [31:0] T1;
wire [31:0] T2;
wire [31:0] E1;
wire [31:0] E0;
wire [31:0] temp1;
wire [31:0] temp2;
wire [31:0] temp3;
reg [1:0] count_for_compute;
always@(posedge clk)										//Counter to read in elements of H from hk_storage module
if (reset)
	count_h<=6'h0;
else if (start1)
	count_h<=6'h0;
else if (count_h1==7'h8 && count_h!=7'h0a)
	count_h<=count_h+1'b1;
always@(posedge clk)										//Counter for counting the number of iterations
if (reset)
	count_in<=6'h0;
else if (start1)
	count_in<=6'h0;
else if (count_h2==6'he && count_in!=7'h41)
	count_in<=count_in+1'b1;
always@(posedge clk)										//Counter for synchronizing the reading in of H elements and starting of computation
if (reset)
	count_for_compute<=6'h0;
else if(start1)
	count_for_compute<=6'h0;
else if (count_h2==6'he && count_for_compute!=2'h1)
	count_for_compute<=count_for_compute+1'b1;
always@(posedge clk)									
if (reset)
begin
	K<=0;
	W<=0;
end
else
begin
K<=K_out;
W<=W_out; 
end
//Functions for computation
assign Ch=(H[4]&H[5])^((~H[4])&H[6]);
assign E1=(({H[4],H[4]}>>6)^({H[4],H[4]}>>11))^({H[4],H[4]}>>25);
assign temp1=Ch+E1;
assign temp2=temp1+H[7];
assign temp3=K_out+W_out;
assign T1=temp2+temp3;
assign Maj=(H[0]&H[1])^(H[0]&H[2])^(H[1]&H[2]);
assign E0=(({H[0],H[0]}>>2)^({H[0],H[0]}>>13))^({H[0],H[0]}>>22);
assign T2=Maj+E0;
always@(posedge clk)										//Iterations performed on a-h registers
if (reset)
begin
for (i=0;i<8;i=i+1)begin
	H[i]<=0;
end
end
else if (count_in!=7'h41 && count_for_compute==2'h1)
begin
H[7]<=H[6];
H[6]<=H[5];
H[5]<=H[4];
H[4]<=H[3]+T1;
H[3]<=H[2];
H[2]<=H[1];
H[1]<=H[0];
H[0]<=T1+T2;
end
else if (count_h1==7'h8 && count_h!=7'h9)
	H[count_h-1'b1]<=H_out;
always@(posedge clk)										//Counter to generate index for outputting final result after 64 iterations
if (reset)
	h_index<=0;
else if (start1)
	h_index<=0;
else if (count_in==7'h41 && h_index!=7'h8)
	h_index<=h_index+1'b1;
always@(posedge clk)										//Outputting final results
if (reset)
	Hash_final<=0;
else if (count_in!=7'h41)
	Hash_final<=0;
else if (h_index!=7'h8)
	Hash_final<=H[h_index];
endmodule

//Module for reading in H and K elements
module hk_storage(clk,reset,data1,data2,start1,H_out,K_out,row_select,count_h,Hash_final,Hash_out,count_in,internal_finish,dom__write,write_h,hmem__write,kmem__write);
integer x,y,z;
input clk,reset,start1;
input [31:0] data1;
input [31:0] data2;
output [31:0] H_out;
output [31:0] K_out;
output [31:0] Hash_out;
output internal_finish;
input [31:0] Hash_final;
input [5:0] row_select;
output [6:0] count_h;
input [6:0] count_in;
output dom__write;
output hmem__write;
output kmem__write;
output [6:0] write_h;
reg [31:0] K[63:0];
reg [31:0] H[7:0];
reg [31:0] computed_h[7:0];
reg [31:0] H_out;
reg [31:0] K_out;
reg [31:0] Hash_out;
reg [6:0] count_k;
reg [6:0] count_h;
reg [6:0] count_hout;
reg [6:0] count_kout;
reg [6:0] final_count;
reg [6:0] write_h;
reg flag;
reg internal_finish;
reg dom__write;
reg hmem__write;
reg kmem__write;


always@(posedge clk)										//Counter for reading in K elements from K memory
if (reset)
begin
	count_k<=6'h0;
	kmem__write<=1'b0;
end
else if(start1)
begin 
	count_k<=6'h0;
	kmem__write<=1'b0;
end
else if (count_k!=7'h40)
begin
	count_k<=count_k+1'b1;
	kmem__write<=1'b0;
end
always@(posedge clk)										//Counter for reading in H elements from H memory 
if (reset)
begin
	count_h<=6'h0;
	hmem__write<=1'b0;
end
else if(start1)
begin
	count_h<=6'h0;
	hmem__write<=1'b0;
end
else if (count_h!=7'h8)
begin
	count_h<=count_h+1'b1;
	hmem__write<=1'b0;
end
always@(posedge clk)										//Outputting H elements for computation
if (reset)
	count_hout<=6'h0;
else if(start1)
	count_hout<=6'h0;
else if (count_hout!=7'h8 && count_h==7'h8)
	count_hout<=count_hout+1'b1;
always@(posedge clk)										//Outputting K elements for computation
if (reset)
	count_kout<=6'h0;
else if (start1)
	count_kout<=6'h0;
else if (row_select==6'he && count_kout!=7'h40)
	count_kout<=count_kout+1'b1;
always@(posedge clk)										//Counter for reading in results after 64 iterations
if (reset)
begin
	final_count<=6'h0;
end
else if (start1)
begin 
	final_count<=6'h0;
end
else if (final_count!=7'h9 && count_in==7'h41)
	final_count<=final_count+1'b1;
always@(posedge clk)										//Storing elements of K in K array
if (reset)
begin
for (x=0;x<64;x=x+1)begin
	K[x]<=0;
end
end
else
	K[count_k]<=data1;
always@(posedge clk)										//Outputting elements of H array
if (reset)
	H_out<=0;
else if (count_h!=7'h8)
	H_out<=0;
else if (count_hout!=7'h8)
	H_out<=H[count_hout];
always@(posedge clk)										//Outputting elements of K array
if (reset)
	K_out<=0;
else if (row_select!=6'he)
	K_out<=0;
else if (count_kout!=7'h40)
	K_out<=K[count_kout];
always@(posedge clk)										//Storing the results after 64 iterations
if (reset)
begin
for (z=0;z<8;z=z+1)begin
	computed_h[z]<=0;
end
end
else if (final_count!=7'h9 && count_in==7'h41)
	computed_h[final_count-1'h1]<=Hash_final;
always@(posedge clk)										//Computation of final hash for given message
if (reset)
begin
	for (y=0;y<8;y=y+1)
	begin
	H[y]<=0;
	end
	flag<=0;
end
else if(start1)
	flag<=0;
else if (final_count==7'h9 && flag!=1'b1)
begin
H[0]<=computed_h[0]+H[0];
H[1]<=computed_h[1]+H[1];
H[2]<=computed_h[2]+H[2];
H[3]<=computed_h[3]+H[3];
H[4]<=computed_h[4]+H[4];
H[5]<=computed_h[5]+H[5];
H[6]<=computed_h[6]+H[6];
H[7]<=computed_h[7]+H[7];
flag<=1'b1;
end
else
begin
	H[count_h]<=data2;
end
always@(posedge clk)										//Counter for outputting final hash to output memory 
if (reset)
	write_h<=6'h0;
else if (start1)
	write_h<=6'h0;
else if (flag==1'b1 && write_h!=7'ha)
	write_h<=write_h+1'b1;
always@(posedge clk)										//Outputting final hash to output memory
if (reset)
begin
	Hash_out<=0;
	dom__write<=0;
end
else if (write_h!=7'ha && flag==1'b1)
begin
	Hash_out<=H[write_h-2'b10];
	dom__write<=1'b1;
end
always@(posedge clk)										//Setting internal finish high after outputting final hash
if (reset)
	internal_finish<=0;
else if (write_h==7'ha)
	internal_finish<=1'b1;
endmodule

