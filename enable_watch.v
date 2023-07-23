`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06.04.2023 10:55:39
// Design Name: 
// Module Name: WATCH
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module enable_watch(
    input clk,
    input reset,
    input enable,
    output reg [3:0]Anode_Activate ,
    output reg [6:0]Cathode_Activate,
    output reg [4:0]hrs
    
    );
    reg [5:0]sec;
     reg [5:0]min;
    wire clk_1Hz;
    clkd (clk,clk_1Hz);
    always @(posedge(clk_1Hz) or posedge(reset))
    begin
        if(reset == 1'b1 )
        begin
        sec = 0 ;
        min = 0;
        hrs = 0;    
        end
        
       else 
       begin
       if(enable ==1 )
       begin
            sec = 45;
            min = 59;
            hrs = 23;
            sec = sec+1;
          if(sec == 60) 
            begin
             sec = 0;
             min = min +1;
                         
                if(min == 60)
                 begin
                  min = 0;
                  hrs = hrs +1;
                        if(hrs == 24)
                        begin
                        hrs = 0;
                        end
                 end
            end
        end
        
        else 
        begin
          sec = sec+1;
            if(sec == 60) 
            begin
             sec = 0;
             min = min +1;
            
                if(min == 60)
                 begin
                  min = 0;
                  hrs = hrs +1;
                        if(hrs == 24)
                        begin
                        hrs = 0;
                        end
                 end
            end
         end
            
        end
    end
    
    reg [3:0] LED_BCD;
    reg [19:0] refresh_counter; 
    wire [1:0] LED_activating_counter;
    
    always @(posedge clk or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    
        assign LED_activating_counter = refresh_counter[19:18];

always @(*)
    begin
        case(LED_activating_counter)
        2'b00: begin
            Anode_Activate = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            LED_BCD = min/10;
            // the first digit of the 16-bit number
              end
        2'b01: begin
            Anode_Activate = 4'b1011; 
            // activate LED2 and Deactivate LED1, LED3, LED4
            LED_BCD = min %10;
            // the second digit of the 16-bit number
              end
        2'b10: begin
            Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED2, LED1, LED4
            LED_BCD = sec/10;
            // the third digit of the 16-bit number
                end
        2'b11: begin
            Anode_Activate = 4'b1110; 
            // activate LED4 and Deactivate LED2, LED3, LED1
            LED_BCD = sec % 10;
            // the fourth digit of the 16-bit number    
               end
        endcase
    end
    
    always @(*)
    begin
        case(LED_BCD)
        4'b0000: Cathode_Activate = 7'b0000001; // "0"     
        4'b0001: Cathode_Activate = 7'b1001111; // "1" 
        4'b0010: Cathode_Activate = 7'b0010010; // "2" 
        4'b0011: Cathode_Activate = 7'b0000110; // "3" 
        4'b0100: Cathode_Activate = 7'b1001100; // "4" 
        4'b0101: Cathode_Activate = 7'b0100100; // "5" 
        4'b0110: Cathode_Activate = 7'b0100000; // "6" 
        4'b0111: Cathode_Activate = 7'b0001111; // "7" 
        4'b1000: Cathode_Activate = 7'b0000000; // "8"     
        4'b1001: Cathode_Activate = 7'b0000100; // "9" 
        default: Cathode_Activate = 7'b0000001; // "0"
        endcase
    end
endmodule
