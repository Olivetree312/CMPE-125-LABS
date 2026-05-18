module vending (
    input  wire clk,
    input wire btnC,
    input  wire [2:0] sw,
    output reg  [6:0] seg,
    output reg  [3:0] an
);

    localparam S0  = 3'b000;
    localparam S5  = 3'b001;
    localparam S10 = 3'b010;
    localparam S15 = 3'b011;
    localparam S20 = 3'b100;

//state= 2b'S0, next_state=2'b
    reg [2:0] state = S0, next_state;

    wire new_input_on;
    //rising edge
    assign new_input_on = (sw & ~sw_prev) != 3'b000;

    reg [2:0] sw_prev = 3'b000;
    wire [2:0] coin_pulse;

    //register coin iff curr switch down & last switch up
    //falling edge
    assign coin_pulse = (~sw) & sw_prev;
//get inputs
    wire N = coin_pulse[0];
    wire D = coin_pulse[1];
    wire Q = coin_pulse[2];

    reg dispense;
    reg return_nickel;
    reg return_dime;
    reg return_two_dimes;

    //latches prev outputs so they stay displayed
    reg disp_latched = 1'b0;
    reg rn_latched   = 1'b0;
    reg rd_latched   = 1'b0;
    reg r2d_latched  = 1'b0;

//storing prev vals w nonblocking assignments -> RHS calc first
    always @(posedge clk) begin
        if (btnC) begin
        state        <= S0;
        sw_prev      <= 3'b000;
        disp_latched <= 1'b0;
        rn_latched   <= 1'b0;
        rd_latched   <= 1'b0;
        r2d_latched  <= 1'b0;
    end
    else begin
        sw_prev <= sw;
        state   <= next_state;
            // clear display as soon as a new switch is flipped ON
    if (new_input_on) begin
        disp_latched <= 1'b0;
        rn_latched   <= 1'b0;
        rd_latched   <= 1'b0;
        r2d_latched  <= 1'b0;
    end
 end       
//storing prev switch, curr state, prev output
        if (coin_pulse != 3'b000) begin
            disp_latched <= dispense;
            rn_latched   <= return_nickel;
            rd_latched   <= return_dime;
            r2d_latched  <= return_two_dimes;
        end
    end
//combinational logic following fsm diagram
    always @(*) begin
        next_state       = state;
        dispense         = 1'b0;
        return_nickel    = 1'b0;
        return_dime      = 1'b0;
        return_two_dimes = 1'b0;
            
        case (state)
            S0: begin
                if (N) begin
                    next_state = S5;
                end
                else if (D) begin
                    next_state = S10;
                end
                else if (Q) begin
                    next_state = S0;
                    dispense   = 1'b1;
                end
            end

            S5: begin
                if (N) begin
                    next_state = S10;
                end
                else if (D) begin
                    next_state = S15;
                end
                else if (Q) begin
                    next_state    = S0;
                    dispense      = 1'b1;
                    return_nickel = 1'b1;
                end
            end

            S10: begin
                if (N) begin
                    next_state = S15;
                end
                else if (D) begin
                    next_state = S20;
                end
                else if (Q) begin
                    next_state   = S0;
                    dispense     = 1'b1;
                    return_dime  = 1'b1;
                end
            end

            S15: begin
                if (N) begin
                    next_state = S20;
                end
                else if (D) begin
                    next_state = S0;
                    dispense   = 1'b1;
                end
                else if (Q) begin
                    next_state    = S0;
                    dispense      = 1'b1;
                    return_nickel = 1'b1;
                    return_dime   = 1'b1;
                end
            end

            S20: begin
                if (N) begin
                    next_state = S0;
                    dispense   = 1'b1;
                end
                else if (D) begin
                    next_state    = S0;
                    dispense      = 1'b1;
                    return_nickel = 1'b1;
                end
                else if (Q) begin
                    next_state       = S0;
                    dispense         = 1'b1;
                    return_two_dimes = 1'b1;
                end
            end

            default: begin
                next_state = S0;
            end
        endcase
    end

    reg [15:0] refresh_counter = 16'd0;
    wire [1:0] digit_sel;

    always @(posedge clk) begin
        refresh_counter <= refresh_counter + 16'd1;
    end

    assign digit_sel = refresh_counter[15:14];

    always @(*) begin
        an  = 4'b1111;
        seg = 7'b1111111;

        case (digit_sel)
            2'b00: begin
                an = 4'b1110;
                if (rn_latched) begin
                    seg = 7'b0010010;
                end
                else if (rd_latched) begin
                    seg = 7'b1000000;
                end
                else if (r2d_latched) begin
                    seg = 7'b1000000;
                end
            end

            2'b01: begin
                an = 4'b1101;
                if (rd_latched) begin
                    seg = 7'b1111001;
                end
                else if (r2d_latched) begin
                    seg = 7'b0100100;
                end
            end

            2'b10: begin
                an = 4'b1011;
                if (disp_latched) begin
                    seg = 7'b0100001;
                end
            end

            2'b11: begin
                an  = 4'b0111;
                seg = 7'b1111111;
            end
        endcase
    end

endmodule