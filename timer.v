module timer(
    input clk,
    input reset,
    input timer_start, timer_tick,
    output timer_up
    );

    reg [6:0] timer_reg, timer_next;
    
    always @(posedge clk or posedge reset)
        if(reset)
            timer_reg <= 7'b1111111;
        else
            timer_reg <= timer_next;

    always @*
        if(timer_start)
            timer_next = 7'b1111111;
        else if((timer_tick) && (timer_reg != 0))
            timer_next = timer_reg - 1;
        else
            timer_next = timer_reg;
            
    assign timer_up = (timer_reg == 0);
    
endmodule