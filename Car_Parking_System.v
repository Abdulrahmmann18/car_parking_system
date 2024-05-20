module Car_Parking_System  #(parameter PASSWORD_LENGTH = 8, GARAGE_PASS = 8'b00001111)
(
	input wire 						 clk,
	input wire 						 rst_n,
	input wire 						 Sensor_entrance,
	input wire 						 Sensor_exit,
	input wire [PASSWORD_LENGTH-1:0] Garage_password,
	output wire 					 Green_led,
	output wire 					 Red_led
);

	localparam IDLE = 3'b000,
			   WAIT_PASSWORD = 3'b001,
			   RIGHT_PASS = 3'b010,
			   WRONG_PASS = 3'b011,
			   STOP = 3'b100;
			   

	reg [2:0] CS, NS;
	
	// next state logic
	always @(*) begin
		case (CS)
			IDLE :
			begin
				if (~Sensor_entrance)
					NS = IDLE;
				else if (Sensor_entrance)
					NS = WAIT_PASSWORD;				
			end

			WAIT_PASSWORD :
			begin
				if (Garage_password != GARAGE_PASS)
					NS = WRONG_PASS;
				else if (Garage_password == GARAGE_PASS)
					NS = RIGHT_PASS;
			end

			RIGHT_PASS :
			begin
				if (~Sensor_exit)
					NS = RIGHT_PASS;
				else if (Sensor_exit && ~Sensor_entrance)
					NS = IDLE;
				else if (Sensor_exit && Sensor_entrance)
					NS = STOP;
			end

			WRONG_PASS :
			begin
				if (Garage_password != GARAGE_PASS)
					NS = WRONG_PASS;
				else if (Garage_password == GARAGE_PASS)
					NS = RIGHT_PASS;
			end

			STOP :
			begin
				if (Garage_password != GARAGE_PASS)
					NS = STOP;
				else if (Garage_password == GARAGE_PASS)
					NS = RIGHT_PASS;
			end
			default :
			begin
				NS = IDLE;
			end
		endcase
	end
	
	// state memory
	always @(posedge clk or negedge rst_n) begin
		if (~rst_n) begin
			CS <= IDLE;
		end
		else begin
			CS <= NS;
		end
	end
	// output logic
	assign Green_led = (CS == RIGHT_PASS) ? 1'b1 : 1'b0 ;
	assign Red_led = (CS == WRONG_PASS) ? 1'b1 : 1'b0 ;

endmodule