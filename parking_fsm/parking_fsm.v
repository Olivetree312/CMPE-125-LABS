module parking_fsm (
    input  wire clk,
    input  wire rst_n, 
    input  wire entrance_sensor,
    input  wire exit_sensor,
    input  wire [3:0] pw,
    output reg  entrance_gate,
    output reg  exit_gate
);
    // arbitrary stored password
    parameter [3:0] PASS = 4'b1010;
    // states
    localparam S0_IDLE     = 3'b000;
    localparam S1_WAIT_IN  = 3'b001;
    localparam S2_OPEN_IN  = 3'b010;
    localparam S3_PARKED   = 3'b011;
    localparam S4_WAIT_OUT = 3'b100;
    localparam S5_OPEN_OUT = 3'b101;
    
    reg [2:0] state, next_state;
    reg [2:0] count; //need 3 bits to count to 5
    wire pw_ok;
    wire timer_done;
    
    assign pw_ok = (pw == PASS);
    assign timer_done = (count == 3'd5);
    // state reg
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= S0_IDLE;
        else
            state <= next_state;
    end
    // counter logic, only when car at closed gates
    //using both pos & neg edge as counts
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 3'd0;
        end
        else begin
            case (state)
                S1_WAIT_IN: begin
                    if (!entrance_sensor)
                        count <= 3'd0;
                    else if (timer_done)
                        count <= 3'd0;
                    else
                        count <= count + 3'd1;
                end

                S4_WAIT_OUT: begin
                    if (!exit_sensor)
                        count <= 3'd0;
                    else if (timer_done)
                        count <= 3'd0;
                    else
                        count <= count + 3'd1;
                end

                default: count <= 3'd0;
            endcase
        end
    end
    // next-state logic, combinational
    always @(*) begin
        next_state = state;

        case (state)
            S0_IDLE: begin
                if (entrance_sensor)
                    next_state = S1_WAIT_IN;
                else
                    next_state = S0_IDLE;
            end

            S1_WAIT_IN: begin
                if (!entrance_sensor)
                    next_state = S0_IDLE;
                else if (!timer_done)
                    next_state = S1_WAIT_IN;
                else if (pw_ok)
                    next_state = S2_OPEN_IN;
                else
                    next_state = S1_WAIT_IN; // retry on wrong pw
            end

            S2_OPEN_IN: begin
                if (entrance_sensor)
                    next_state = S2_OPEN_IN;
                else
                    next_state = S3_PARKED;
            end

            S3_PARKED: begin
                if (exit_sensor)
                    next_state = S4_WAIT_OUT;
                else
                    next_state = S3_PARKED;
            end

            S4_WAIT_OUT: begin
                if (!exit_sensor)
                    next_state = S3_PARKED;
                else if (!timer_done)
                    next_state = S4_WAIT_OUT;
                else if (pw_ok)
                    next_state = S5_OPEN_OUT;
                else
                    next_state = S4_WAIT_OUT; // retry on wrong pw
            end

            S5_OPEN_OUT: begin
                if (exit_sensor)
                    next_state = S5_OPEN_OUT;
                else
                    next_state = S0_IDLE;
            end

            default: next_state = S0_IDLE;
        endcase
    end
    // output logic (Moore outputs)
    always @(*) begin
        entrance_gate = 1'b0;
        exit_gate     = 1'b0;
        case (state)
            S2_OPEN_IN:  entrance_gate = 1'b1;
            S5_OPEN_OUT: exit_gate     = 1'b1;
            default: begin
                entrance_gate = 1'b0;
                exit_gate     = 1'b0;
            end
        endcase
    end

endmodule