//Tal-Aya Shefi, Gil Yair Sherman
//missile_move
//detirmines the movement of a missile

module missile_move	(	
 
		input	logic	clk,
		input	logic	resetN,
		input	logic	startOfFrame,        	// short pulse every start of frame 30Hz
		
		input logic fire,							//at posedge move to initial X position, start movement
		input logic hit,							//stop movement
		input logic [10:0] playerPositionX,	//initial x position 
		
		output	logic	[10:0]	object_topLeftX,// output the top left corner 
		output	logic	[10:0]	object_topLeftY
		
);


parameter int INITIAL_X = 0;
parameter int INITIAL_Y = 450;
parameter int Y_SPEED = -10;

parameter int SPACESHIP_SIZE = 20;

const int	MULTIPLIER	=	64;
// multiplier is used to work with integers in high resolution 
// we devide at the end by multiplier which must be 2^n 
const int	x_FRAME_SIZE	=	639 * MULTIPLIER;
const int	y_FRAME_SIZE	=	479 * MULTIPLIER;

int topLeftX_tmp, topLeftY_tmp; // local parameters 
logic firing; //object state, 1-fire, 0-dont fire

logic mid_spaceship;

// position calculate 

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
always_ff@(posedge clk or negedge resetN)
begin
	if(!resetN)
	begin
		topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
		topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
		firing <= 0;
	end
	else begin	
		if((hit == 1'b1) || (topLeftY_tmp <= 5 ))
		begin
			topLeftX_tmp	<= INITIAL_X * MULTIPLIER;
			topLeftY_tmp	<= INITIAL_Y * MULTIPLIER;
			firing <= 0;
		end
		else begin
					
			if (fire == 1'b1) begin
				firing <= 1'b1;
				
				////////////
				//this can be a *bug*.
				//due to the late "all together calculation of everything
				//if needed, move to a single, without variable, line
				//plz try to come up with a better idea,
				// trying to calculate mid_spaceship outside of am always block
				// is doomed to fail.
				////////////
				
				
				mid_spaceship <= playerPositionX + SPACESHIP_SIZE/2 ;
				topLeftX_tmp <= mid_spaceship * MULTIPLIER;
			end
				
			if (startOfFrame == 1'b1 && firing == 1'b1) begin //startOfFrame perform only 30 times per second, fire determines the movement
				topLeftY_tmp  <= topLeftY_tmp + Y_SPEED; 
			end
		end
	end
end

//=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
//get a better (64 times) resolution using integer   
assign 	object_topLeftX = topLeftX_tmp / MULTIPLIER ;   // note:  it must be 2^n 
assign 	object_topLeftY = topLeftY_tmp / MULTIPLIER ;    


endmodule
