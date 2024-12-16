extends Node2D

const COLLISION_MASK_TUI = 1

#-----------------------------TUI---------------------------
var tui_skin : String = "default"
# Define the structure of each card (tui)
class Tui:
	var name: String
	var priority: int
	func _init(name: String, priority: int):
		self.name = name
		self.priority = priority
		
# List of tuis (tui) with names and priorities
var tuis = []
enum e_tui_val{
	B_7,R_7, #chip
	B_6,R_6, #house
	B_5,R_5, #horse
	B_4,R_4, #boat
	B_3,R_3, #elephant
	B_2,R_2, #plane
	B_1,R_1  #king
}

var screen_size

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Gvar.game_state:
		Gvar.e_state.INIT:
			initialize_tuis()
			shuffle_and_distribute_cards()
			print_player_cards()
			#animation
			Gvar.game_state = Gvar.e_state.HANDING
			print("state to HANDING")
			for i in 4:
				Gvar.players_hand_ready_status[i] = false #ONLINE NEED CHECK
		Gvar.e_state.HANDING:
			var ready_count = 0
			for i in 4:
				if Gvar.players_hand_ready_status[i] == true: #ONLINE NEED CHECK
					ready_count += 1
			if ready_count == 4:
				Gvar.game_state = Gvar.e_state.SELECTING
				print("state to SELECTING")
		Gvar.e_state.WAITING_TO_SELECT:
			pass
		Gvar.e_state.SELECTING:
			var confirm_count = 0
			for i in 4:
				if Gvar.players_confirm_hand_status[i] == true: #ONLINE NEED CHECK
					confirm_count += 1
			if confirm_count == 4:
				Gvar.game_state = Gvar.e_state.CHECKING
				print("state to CHECKING")
		Gvar.e_state.CHECKING:
			pass
		Gvar.e_state.RESULT:
			pass
		_:
			pass

func raycast_check_for_tui():
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = COLLISION_MASK_TUI
	var result = space_state.intersect_point(params)
	if result.size() > 0:
		print("click on: ", result[0].collider.get_parent())
		return result[0].collider.get_parent()
	else:
		return null

# Initialize all the 32 tui with names and priorities
func initialize_tuis():
	tuis.append(Tui.new("Red King", e_tui_val.R_1))
	tuis.append(Tui.new("Black King", e_tui_val.B_1))
	
	for i in range(2):
		tuis.append(Tui.new("Red Plane",  e_tui_val.R_2))
		tuis.append(Tui.new("Black Plane", e_tui_val.B_2))
	
	for i in range(2):
		tuis.append(Tui.new("Red Elephant",  e_tui_val.R_3))
		tuis.append(Tui.new("Black Elephant", e_tui_val.B_3))
	
	for i in range(2):
		tuis.append(Tui.new("Red Boat",  e_tui_val.R_4))
		tuis.append(Tui.new("Black Boat", e_tui_val.B_4))

	for i in range(2):
		tuis.append(Tui.new("Red Horse",  e_tui_val.R_5))
		tuis.append(Tui.new("Black Horse", e_tui_val.B_5))
	
	for i in range(2):
		tuis.append(Tui.new("Red House",  e_tui_val.R_6))
		tuis.append(Tui.new("Black House", e_tui_val.B_6))
	
	for i in range(5):
		tuis.append(Tui.new("Red Chip", e_tui_val.B_7))
		tuis.append(Tui.new("Black Chip", e_tui_val.B_7))
	
	print("Tuis initialized!")

func shuffle_and_distribute_cards():
	tuis.shuffle()
	var player_keys = Gvar.player_hand.keys()
	for i in range(tuis.size()):
		var player = player_keys[i % 4]  # Distribute evenly among 4 players
		Gvar.player_hand[player].append(tuis[i])
	print("Tuis shuffled and distributed!")

# Print the cards for each player --------------- DEBUG
func print_player_cards():
	for player in Gvar.player_hand:
		print(player, "'s Tuis:")
		for tui in Gvar.player_hand[player]:
			print("\t", tui.name, " (Priority: ", tui.priority, ")")
