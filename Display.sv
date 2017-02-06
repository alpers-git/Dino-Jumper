`timescale 1ns / 1ps

module Display(input logic CLOCK,
              input logic [2:0] x,
              input logic [2:0] y,
              input logic [2:0] obsx,
              input logic [2:0] obsType,
              output logic SH_CP, ST_CP, reset, DS, OE,
              output logic[7:0] KATOT);
//Code below is translated by Alper Þahýstan, Batuhan Kaynak from VDL Code provided by Lab Engineer Özge Sancar
    logic [23:0] msg ;
    logic [7:0] red, green, blue;
    assign msg[23:16] = red;
    assign msg[15:8]  = green;
    assign msg[7:0]   = blue;
    
    logic f;
    logic e;
    
    logic [7:0] counter=0;
    logic [8:0] index =1; //i
    logic [6:0] frame = 0; //d
    logic [2:0] rowNum= 0; //a
    
    always @(posedge CLOCK)
        counter = counter+1;
    
    assign f = counter[7];
    assign e =~f;
    
    always @(posedge e)
        index = index +1;
    
    always_comb
    begin
        if (index<4) 
            reset=0;
       else
            reset=1;
    
    
        if (index>3 && index<28) 
             DS=msg[index-4];
        else 
            DS=0;
    
        if (index<28)
        begin
            SH_CP=f;                
            ST_CP=e;
        end
	   else
         begin
        SH_CP=0;
        ST_CP=1;
         end
    end//of always_comb
     
    always@ (posedge f)
    begin
        if (index>28 && index<409)
            OE<=0;
	else
            OE<=1;
        if (index== 410)
        begin
          rowNum <= rowNum+1;
            if (rowNum==7)
                frame <= frame+1;
        end     
    end
    
    always_comb
    begin
        if (rowNum==0) begin 
            KATOT<=8'b10000000;
        end
        else if(rowNum==1)  begin
            KATOT<=8'b01000000;
        end
        else if (rowNum==2)  begin
            KATOT<=8'b00100000;
        end
        else if (rowNum==3)  begin
            KATOT<=8'b00010000;
        end
        else if (rowNum==4)  begin
            KATOT<=8'b00001000;
        end
        else if (rowNum==5)  begin
            KATOT<=8'b00000100;
        end
        else if (rowNum==6)  begin
            KATOT<=8'b00000010;
        end
        else
            KATOT<=8'b00000001;
//Code above is translated by Alper Þahýstan, Batuhan Kaynak from VDL Code provided by Lab Engineer Özge Sancar
       case(obsType)
            0:begin//Cubic Obstacle
               if(rowNum==1)
               begin
                 for (int it =0; it<8 ; it++)
                 begin
                     if (it == obsx)
                         red[it]=1;
                    else if (it == (obsx+1))
                         red[it]=1;
                     else
                         red[it]=0;
                 end
                end
                
                else if(rowNum==2)
                begin
                    for (int it =0; it<8 ; it++)
                    begin
                        if (it == obsx)
                            red[it]=1;
                        else if (it == (obsx+1))
                            red[it]=1;
                        else
                            red[it]=0;
                    end
                end
                
                else
                begin
                     for (int it =0; it<8 ; it++)
                     begin
                         red[it]=0;
                     end
                end
            end
            1:begin //Stick Obstacle (--)
                if(rowNum==1)
                begin
                     for (int it =0; it<8 ; it++)
                     begin
                         if (it == obsx)
                             red[it]=1;
                        else if (it == (obsx+1))
                             red[it]=1;
                         else
                             red[it]=0;
                     end
                end   
                else
                begin
                     for (int it =0; it<8 ; it++)
                     begin
                         red[it]=0;
                     end
                end
            end
            
            2:begin//Staircase Obstacle
                if(rowNum==1)
               begin
                 for (int it =0; it<8 ; it++)
                 begin
                     if (it == obsx)
                         red[it]=1;
                    else if (it == (obsx+1))
                         red[it]=1;
                     else
                         red[it]=0;
                 end
                end
                
                else if(rowNum==2)
                begin
                    for (int it =0; it<8 ; it++)
                    begin
                        if (it == obsx+1)
                            red[it]=1;
                        else
                            red[it]=0;
                    end
                end
                
                else
                begin
                     for (int it =0; it<8 ; it++)
                     begin
                         red[it]=0;
                     end
                end
            end
            
            3:begin//T
               if(rowNum==1)
                begin
                    for (int it =0; it<8 ; it++)
                    begin
                        if (it == obsx)
                            red[it]=1;
                        else
                            red[it]=0;
                    end     
                end
                
                else if(rowNum==2)
                begin
                     for (int it =0; it<8 ; it++)
                     begin
                         if (it == obsx-1)
                             red[it]=1;
                        else if (it == (obsx+1))
                             red[it]=1;
                        else if (it == obsx)
                            red[it]=1;
                         else
                             red[it]=0;
                     end
                end              
                else
                begin
                     for (int it =0; it<8 ; it++)
                     begin
                         red[it]=0;
                     end
                end
            end
       endcase     
       if(rowNum == (y)) begin  
       for (int it =0; it<8 ; it++)
           begin
            if (it == (x-1))
                blue[it] =1;
            else if (it == (x))
                blue[it] =1;
            else
                blue[it] = 0;
            //green[it]=0;
           end
       end
       
       else if(rowNum == (y+1)) begin  
              for (int it =0; it<8 ; it++)
                  begin
                   if (it == (x))
                       blue[it] =1;
                   else
                       blue[it] = 0;
                   //green[it]=0;
                end
        end
        
        else if(rowNum == (y+2)) begin  
               for (int it =0; it<8 ; it++)
                   begin
                    if (it == (x+1))
                        blue[it] =1;
                    else if (it == (x))
                        blue[it] =1;
                    else
                        blue[it] = 0;
                    //green[it]=0;
               end
       end
       else if(rowNum == (y+3)) begin  
              for (int it =0; it<8 ; it++)
                  begin
                   if (it == (x+1))
                       blue[it] =1;
                   else if (it == (x))
                       blue[it] =1;
                   else
                       blue[it] = 0;
                   //green[it]=0;
              end
      end       
       else
       begin
        for (int it =0; it<8 ; it++)
              begin
               blue[it] = 0;
               //green[it]=0;
          end
       end
       
       if(rowNum==0)
       begin
         for (int it =0; it<8 ; it++)
         begin
             green[it] = 1;
         end
      end
      
      else
      begin
        for (int it =0; it<8 ; it++)
        begin
            green[it] = 0;
        end
      end
            
       /*if(rowNum == (y)) begin
                case(x)
                    7:
                    begin
                      red<=8'b00000000;
                      green<=8'b11000000;
                      blue<=8'b00000000;  
                    end
                    6:
                    begin
                      red<=8'b00000000;
                      green<=8'b01100000;
                      blue<=8'b00000000;  
                    end
                    5:
                    begin
                       red<=8'b00000000;
                       green<=8'b00110000;
                       blue<=8'b00000000; 
                    end
                    4:
                    begin
                       red<=8'b00000000;
                       green<=8'b00011000;
                       blue<=8'b00000000; 
                    end
                    3:
                    begin
                      red<=8'b00000000;
                      green<=8'b00001100;
                      blue<=8'b00000000; 
                    end
                    2:
                    begin
                      red<=8'b00000000;
                      green<=8'b00000110;
                      blue<=8'b00000000; 
                    end
                    1:
                    begin
                      red<=8'b00000000;
                      green<=8'b00000011;
                      blue<=8'b00000000; 
                    end
                    0:
                    begin
                      red<=8'b00000000;
                      green<=8'b10000001;
                      blue<=8'b00000000; 
                    end
               endcase
                    
            end     
            
            
       else if (rowNum == (y+1))begin
          case(x)
                   7:
                   begin
                     red<=8'b00000000;
                     green<=8'b10000000;
                     blue<=8'b00000000;  
                   end
                   6:
                   begin
                     red<=8'b00000000;
                     green<=8'b01000000;
                     blue<=8'b00000000;  
                   end
                   5:
                   begin
                      red<=8'b00000000;
                      green<=8'b00100000;
                      blue<=8'b00000000; 
                   end
                   4:
                   begin
                      red<=8'b00000000;
                      green<=8'b00010000;
                      blue<=8'b00000000; 
                   end
                   3:
                   begin
                     red<=8'b00000000;
                     green<=8'b00001000;
                     blue<=8'b00000000; 
                   end
                   2:
                   begin
                     red<=8'b00000000;
                     green<=8'b00000100;
                     blue<=8'b00000000; 
                   end
                   1:
                   begin
                     red<=8'b00000000;
                     green<=8'b00000010;
                     blue<=8'b00000000; 
                   end
                   0:
                   begin
                     red<=8'b00000000;
                     green<=8'b00000001;
                     blue<=8'b00000000; 
                   end
              endcase
       end
                 
       else if(rowNum == (y+2)) begin
          case(x)
            7:
            begin
              red<=8'b00000000;
              green<=8'b10000001;
              blue<=8'b00000000;  
            end
            6:
            begin
              red<=8'b00000000;
              green<=8'b11000000;
              blue<=8'b00000000;  
            end
            5:
            begin
               red<=8'b00000000;
               green<=8'b01100000;
               blue<=8'b00000000; 
            end
            4:
            begin
               red<=8'b00000000;
               green<=8'b00110000;
               blue<=8'b00000000; 
            end
            3:
            begin
              red<=8'b00000000;
              green<=8'b00011000;
              blue<=8'b00000000; 
            end
            2:
            begin
              red<=8'b00000000;
              green<=8'b00001100;
              blue<=8'b00000000; 
            end
            1:
            begin
              red<=8'b00000000;
              green<=8'b00000110;
              blue<=8'b00000000; 
            end
            0:
            begin
              red<=8'b00000000;
              green<=8'b00000011;
              blue<=8'b00000000; 
            end
       endcase
            
        end
        
        else
        begin
          red<=8'b00000000;
          blue<=8'b00000000;
          green<=8'b00000000;  
        end
            
        if (rowNum==1)
        begin
            red[obsx]=1;
            red[obsx-1]=1;
        end*/
   end
   
       
endmodule
