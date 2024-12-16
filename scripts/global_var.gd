extends Node

#---------------------------PLAYERS-------------------------
# Define the structure of each player (tui)
class Player:
	var name: String
	var player_order: int
	var player_hand_count: int
	func _init(name: String, player_order: int,player_hand_count):
		self.name = name
		self.player_order = player_order
		self.player_hand_count = player_hand_count
		
enum e_state{
	INIT,
	HANDING,
	WAITING_TO_SELECT,
	SELECTING,
	CHECKING,
	RESULT
}
var game_state = e_state.INIT
#---------------------------Players------------------------
var player_hand = {
	"Player 1": [],
	"Player 2": [],
	"Player 3": [],
	"Player 4": []
}
var player_slot = {
	"Player 1": [],
	"Player 2": [],
	"Player 3": [],
	"Player 4": []
}
var tui_skin_name = {
	"Black Chip": "B_7",
	"Red Chip": "R_7",
	"Black House": "B_6",
	"Red House": "R_6",
	"Black Horse": "B_5",
	"Red Horse": "R_5",
	"Black Boat": "B_4",
	"Red Boat": "R_4",
	"Black Elephant": "B_3",
	"Red Elephant": "R_3",
	"Black Plane": "B_2",
	"Red Plane": "R_2",
	"Black King": "B_1",
	"Red King": "R_1"
}

var players_hand_ready_status = [false,false,false,false]
var players_confirm_hand_status = [false,false,false,false]

# Time variable
var time_accumulator = 0.0  # Accumulates delta each frame
var seconds_count = 0
var minutes_count = 0
var hours_count = 0
var second_flag = false
var minute_flag = false
var hour_flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	second_flag = false
	minute_flag = false
	hour_flag = false
	delta_to_second(delta)
	
func delta_to_second(delta_1):
	time_accumulator += delta_1
	# When the accumulator reaches or exceeds 1 second
	if time_accumulator >= 1.0:
		seconds_count += 1  # Increment the integer timer
		# Subtract 1 second from the accumulator (or reset to 0 for exact intervals)
		time_accumulator -= 1.0
		second_flag = true
	if seconds_count >= 60:
		seconds_count = 0
		minutes_count += 1
		minute_flag = true
	if minutes_count >= 60:
		minutes_count = 0
		hours_count += 1
		hour_flag = true
