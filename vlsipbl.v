module vlsipbl(
    input         clk,
    input         btn0,
    input         btn1,
    input  [15:0] sw,

    output reg [15:0] led,

    output reg [7:0] seg0,
    output reg [3:0] an0,

    output reg [7:0] seg1,
    output reg [3:0] an1,

    output reg rgb0_r,
    output reg rgb0_g,
    output reg rgb0_b,

    output reg rgb1_r,
    output reg rgb1_g,
    output reg rgb1_b
);

    // SW[7:0] = input numerical value
    // SW[9:8] = parameter selection
    // 00 = Temperature
    // 01 = Heart Rate
    // 10 = SpO2
    // 11 = Health Status

    wire [7:0] input_value;
    wire [1:0] parameter_select;

    assign input_value = sw[7:0];
    assign parameter_select = sw[9:8];

    // Stored health parameters
    reg [7:0] temperature;
    reg [7:0] heart_rate;
    reg [7:0] spo2;

    // Store selected parameter
    always @(posedge clk) begin

        if (btn0) begin

            temperature <= 8'd37;
            heart_rate  <= 8'd75;
            spo2        <= 8'd98;

        end
        else begin

            case (parameter_select)

                2'b00:
                    temperature <= input_value;

                2'b01:
                    heart_rate <= input_value;

                2'b10:
                    spo2 <= input_value;

                2'b11:
                    begin
                    end

            endcase

        end

    end

    // Health status
    // 00 = NORMAL
    // 01 = WARNING
    // 10 = CRITICAL

    reg [1:0] health_status;

    always @(*) begin

        if ((temperature >= 8'd39) ||
            (heart_rate > 8'd120) ||
            (heart_rate < 8'd50) ||
            (spo2 < 8'd90)) begin

            health_status = 2'b10;

        end
        else if ((temperature >= 8'd38) ||
                 (heart_rate > 8'd100) ||
                 (heart_rate < 8'd60) ||
                 (spo2 < 8'd95)) begin

            health_status = 2'b01;

        end
        else begin

            health_status = 2'b00;

        end

    end

    // LED indication
    always @(*) begin

        case (health_status)

            // NORMAL
            2'b00:
                led = 16'b0000_0000_0000_1111;

            // WARNING
            2'b01:
                led = 16'b0000_0000_1111_0000;

            // CRITICAL
            2'b10:
                led = 16'b1111_0000_0000_0000;

            default:
                led = 16'b0000_0000_0000_0000;

        endcase

    end

    // RGB LED indication
    always @(*) begin

        rgb0_r = 1'b0;
        rgb0_g = 1'b0;
        rgb0_b = 1'b0;

        rgb1_r = 1'b0;
        rgb1_g = 1'b0;
        rgb1_b = 1'b0;

        case (health_status)

            // NORMAL = GREEN
            2'b00:
            begin
                rgb0_g = 1'b1;
                rgb1_g = 1'b1;
            end

            // WARNING = BLUE
            2'b01:
            begin
                rgb0_b = 1'b1;
                rgb1_b = 1'b1;
            end

            // CRITICAL = RED
            2'b10:
            begin
                rgb0_r = 1'b1;
                rgb1_r = 1'b1;
            end

            default:
            begin
            end

        endcase

    end

    // Select value for seven segment display
    reg [7:0] display_value;

    always @(*) begin

        case (parameter_select)

            2'b00:
                display_value = temperature;

            2'b01:
                display_value = heart_rate;

            2'b10:
                display_value = spo2;

            2'b11:
                display_value = {6'b000000, health_status};

            default:
                display_value = 8'd0;

        endcase

    end

    // Decimal digit conversion
    reg [3:0] ones;
    reg [3:0] tens;
    reg [3:0] hundreds;

    always @(*) begin

        hundreds = display_value / 100;
        tens     = (display_value / 10) % 10;
        ones     = display_value % 10;

    end

    // Seven segment decoder
    // Active LOW
    // 0 = ON
    // 1 = OFF

    function [7:0] seven_segment;

        input [3:0] digit;

        begin

            case (digit)

                4'd0:
                    seven_segment = 8'b1100_0000;

                4'd1:
                    seven_segment = 8'b1111_1001;

                4'd2:
                    seven_segment = 8'b1010_0100;

                4'd3:
                    seven_segment = 8'b1011_0000;

                4'd4:
                    seven_segment = 8'b1001_1001;

                4'd5:
                    seven_segment = 8'b1001_0010;

                4'd6:
                    seven_segment = 8'b1000_0010;

                4'd7:
                    seven_segment = 8'b1111_1000;

                4'd8:
                    seven_segment = 8'b1000_0000;

                4'd9:
                    seven_segment = 8'b1001_0000;

                default:
                    seven_segment = 8'b1111_1111;

            endcase

        end

    endfunction

    // Seven segment output
    always @(*) begin

        an0 = 4'b1110;
        an1 = 4'b1110;

        seg0 = seven_segment(tens);
        seg1 = seven_segment(ones);

    end

endmodule