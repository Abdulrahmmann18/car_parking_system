module Car_Parking_System_tb();

	// signals declaration
	reg clk, rst_n, Sensor_entrance, Sensor_exit;
	reg [7:0] Garage_password; 
	wire Green_led_DUT, Red_led_DUT;
	// DUT Instantiation
	Car_Parking_System DUT(clk, rst_n, Sensor_entrance, Sensor_exit, Garage_password, Green_led_DUT, Red_led_DUT);
	// clk generation block
	initial begin
		clk = 0;
		forever
			#1 clk = ~clk;
	end
	// test stimulus generator
	integer i;
	initial begin
		rst_n = 0;
		Sensor_entrance = 0;
		Sensor_exit = 0;
		Garage_password = 8'b0;
		#50;
		rst_n = 1;
		#50;
		Sensor_entrance = 1;
		for (i=0; i<100; i=i+1) begin
			@(negedge clk)
			Garage_password = $urandom_range(13,15);
		end
		$stop;
	end
	always @(negedge clk) begin
		if (rst_n) begin
			if (Green_led_DUT)
				Sensor_exit = 1;
		end
	end

endmodule