extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Gvar.game_state:
		Gvar.e_state.INIT:
			pass
		Gvar.e_state.HANDING:
			var player_no = "" #ONLINE NEED CHECK
			for i in 3: #ONLINE NEED CHECK
				player_no = "Player " + str(i+1) #ONLINE NEED CHECK
				if Gvar.player_hand[player_no].size() == 8: #ONLINE NEED CHECK
					Gvar.players_hand_ready_status[i+1] = true #ONLINE NEED CHECK
					#animation
		Gvar.e_state.WAITING_TO_SELECT:
			pass
		Gvar.e_state.SELECTING:
			pass
		Gvar.e_state.CHECKING:
			pass
		Gvar.e_state.RESULT:
			pass
		_:
			pass

func ai_player_tui_selection():
	pass
