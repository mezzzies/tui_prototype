extends Node2D

const START_HAND_UNIT_COUNT = 8
const TUI_SCENE_PATH = "res://scenes/tui.tscn"
const TUI_WIDTH = 50
const HAND_Y_POSITION = 900
const REPOSITION_SPEED = 0.8

var tui_skin_path = "res://assests/tui_skins/default/"

var my_player = "Player 1"
var my_hand = []
var center_screen_x
var tui_scene

var handfull_flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tui_scene = preload("res://scenes/tui.tscn")
	center_screen_x = get_viewport().size.x / 2
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Gvar.second_flag:
		print("Gvar.game_state = ", Gvar.game_state)
		print("Gvar.tui_being_dragged_flag = ", Gvar.tui_being_dragged_flag)
	match Gvar.game_state:
		Gvar.e_state.INIT:
			pass
		Gvar.e_state.HANDING:
			my_hand = Gvar.players["Player 1"]
			if handfull_flag:
				Gvar.game_state = Gvar.e_state.WAITING
			else:
				init_tui()
				#animation
		Gvar.e_state.WAITING:
			if Gvar.tui_being_dragged_flag:
				pass
			else:
				update_hand_position()
			pass
		Gvar.e_state.CHECKING:
			pass
		Gvar.e_state.RESULT:
			pass
		_:
			pass

func init_tui() -> void:
	for i in range(START_HAND_UNIT_COUNT):
		var new_tui = tui_scene.instantiate()
		add_child(new_tui)
		
		var image_name = Gvar.players["Player 1"][i].name
		new_tui.name = image_name + str(i+1)
		
		var sprite2D_node = new_tui.get_child(0)
		sprite2D_node.texture = load(tui_skin_path+Gvar.tui_skin_name[image_name]+".png")
		
	handfull_flag = true

func update_hand_position() -> void:
	for i in range(my_hand.size()):
		var new_position = Vector2(calculate_tui_position(i), HAND_Y_POSITION)
		var tui = get_child(i)
		animate_car_to_position(tui,new_position)

func calculate_tui_position(index) -> float:
	var total_width = (my_hand.size() - 1) * TUI_WIDTH
	var x_offset = center_screen_x + (index * TUI_WIDTH) - (total_width / 2)
	return x_offset

func animate_car_to_position(tui, new_position):
	var tween = get_tree().create_tween()
	tween.tween_property(tui, "position", new_position, REPOSITION_SPEED)

func show_hand() -> void:
	pass
