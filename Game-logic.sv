`timescale 1ns / 1ps

module Game_logic(input logic left, right, up, down, CLOCK, displayHighScore,
             output logic SH_CP, ST_CP, reset, DS, OE,
             output logic[7:0] KATOT,
             output logic a, b, c, d, e, f, g, dp,
             output logic [3:0] an);

    logic [2:0] obsx=7;
    logic [2:0] Otype=0;
    logic [2:0] OtypeNext = 0; 
    logic [2:0] obsxNext = 7;
    logic [1:0] delayer = 1;
    logic [1:0] delayerNext = 1;
    logic clk_en;
    logic gameOver=1;
    
    // related to moving the dinosaur
    logic left_flag = 0;
    logic right_flag = 0;
    logic up_enable = 0;
    logic gravity = 0;
    logic [2:0] x = 2;
    logic [2:0] y = 1;
    logic [2:0] xNext  = 2;
    logic [2:0] yNext  = 1;
    
    // related to score measurement
    logic [30:0] count = 0;
    logic [30:0] D = 19000000;
    logic [30:0] DNext = 19000000;  
    logic [13:0] score=0;
    logic [13:0] scoreNext=0;
    logic [13:0] highScore=0;
    logic [13:0] toSevSeg=0;
    logic [3:0] difficultyCounter=0;
    logic [3:0] difficultyCounterNext=0;
    
    // for random state selection
    logic [30:0] randomSeed= 30'b10011000110101011101001001000; // it contains random binary numbers 
    logic [5:0] index = 1; // which state we are using from our random state number array
    
    Display displayer(CLOCK, x, y, obsx,Otype, SH_CP, ST_CP, reset, DS, OE, KATOT);
    SevSeg_4digit scoreDisplay(CLOCK, toSevSeg, a, b, c, d, e, f, g, dp, an);
    always@ (posedge CLOCK) begin
    count <= count + 1;
    if(index==29)
        index=1;
    else
        index++;
    if (count==D) //D: last value for counter
    count <= 30'd0; //N: length of counter
    if (count==30'd0)
    clk_en <= 1'b1;
    else
    clk_en <= 1'b0;
    end
    always@ (posedge CLOCK)
    if (clk_en==1'b1)
    begin
        x<=xNext;
        y<=yNext;
        Otype<=OtypeNext;
        delayer<=delayerNext;
        obsx<=obsxNext;
        score<=scoreNext;
        difficultyCounter<=difficultyCounterNext;
        D<=DNext;    
    end
    
always_ff@(posedge CLOCK)
    begin
        if(~gameOver)
        begin
            toSevSeg<=score;
            if (left && ~ left_flag)
            begin
            left_flag=1;
                if(x!=1)
                    xNext=x-1;
            end
            
            else if (~left)
                left_flag=0;
                
            if (right && ~ right_flag)
            begin
            right_flag=1;
                if(x!=3)   
                  xNext=x+1;
            end
            
            else if (~right)
                right_flag=0;
            
            // Goes up
            if ((up ||  up_enable) && ~gravity)
            begin
                if(y==4)
                begin
                    yNext=y;
                end
                else    
                    yNext=y+1;
                    gravity = (delayer == 0) ? 1: 0;
            up_enable = ~gravity;
            end
            
            else if (~up && y==1)
                up_enable=0;
            
            // goes down    
            if (gravity)
            begin
                if(y==1)
                    yNext=1;
                else    
                    yNext=y-1;
                gravity = (y > 1) ? 1:0;
            end
            
            if(obsx==0)
            begin
                scoreNext=score+10;
                difficultyCounterNext= difficultyCounter+1;
                obsxNext=7;
                OtypeNext= randomSeed[(index)]*2 + randomSeed[(index-1)];     
            end
            else
                obsxNext = obsx-1;
        end
            
        else//Game over 
        begin
            if((left|| right || up))
            begin
                scoreNext=0;
                DNext = 19000000;
                xNext=2;
                yNext=1;
                obsxNext=7;
                difficultyCounterNext=0;
             end
                
                if(highScore<score)//sets highScore
                    highScore<=score;
                if(displayHighScore && gameOver)//Displays Highscore
                    toSevSeg<=highScore;
                else
                    toSevSeg<=score;
        end
        
        if(difficultyCounter==5)//Game gets faster after each 50 points
        begin
            difficultyCounterNext=0;
            if(D>5000000)
                DNext=D-500000;
        end      
    end
    
    always_comb
    begin
        if(y==4)
        begin
            delayerNext=delayer-1;//Dino remains in the air for 1 clock cycles
        end
        if(delayer==0)
        begin
            delayerNext = 1;
        end
            
        case(Otype)//Collisions
        0:
        begin 
            if((x==obsx && y==1) || (x==obsx && y==2) || ((x-1)==(obsx+1) && y==2) || ((x-1)==(obsx) && y==2) || ((x==obsx+1) && y==1))
                gameOver=1;
            else
                gameOver=0;
        end
        
        1:
        begin
            if((x==obsx && y==1) || ((x-1)==(obsx) && y==1) || ((x-1)==(obsx+1) && y==1))
                gameOver=1;
            else
                gameOver=0;
        end
        
        2:
        begin
            if((x==obsx && y==1) || ((x)==(obsx+1) && y==2) || ((x-1)==(obsx+1) && y==2) || ((x==obsx+1) && y==1))
                gameOver=1;
            else
                gameOver=0;
        
        end
        3:
        begin
            if(((x==(obsx-1)) && y==1) || ((x)==(obsx) && y==2) || ((x)==(obsx+1) && y==2) || ((x-1)==(obsx+1)&& y==2) ||((x==(obsx-1)) && y==2)  || ((x==obsx) && y==1))
                gameOver=1;
            else
                gameOver=0;
        end
        endcase
    end
    
    
endmodule