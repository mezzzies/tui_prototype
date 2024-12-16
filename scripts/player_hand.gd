extends Node2D

const START_HAND_UNIT_COUNT = 8
const TUI_SCENE_PATH = "res://scenes/tui.tscn"
const TUI_WIDTH = 100
const HAND_Y_POSITION = 900
const REPOSITION_SPEED = 0.8
const SELECTION_SPEED = 0.05
const TUI_DEFAULT_SCALE = 0.5
const TUI_HIGHLIGHT_SCALE = 0.55
const COLLISION_MASK_TUI = 1

var tui_skin_path = "res://assests/tui_skins/default/"

var my_player = "Player 1"
var my_hand = []
var my_order # ONLINE NEED CHECK
var play_slot = []
var node_mapping = {}
var selected_tui
var center_screen_x
var center_screen_y
var tui_scene
var screen_size

var handfull_flag = false
var hovering_tui_flag = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tui_scene = preload("res://scenes/tui.tscn")
	center_screen_x = get_viewport().size.x / 2
	center_screen_y = get_viewport().size.y / 2
	screen_size = get_viewport_rect().size
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	match Gvar.game_state:
		Gvar.e_state.INIT:
			pass
		Gvar.e_state.HANDING:
			if handfull_flag:
				if Gvar.players_hand_ready_status[0] == false: #ONLINE NEED CHECK
					Gvar.players_hand_ready_status[0] = true #ONLINE NEED CHECK
			else:
				my_hand = Gvar.player_hand["Player 1"]
				init_tui()
				update_hand_position()
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

func init_tui() -> void:
	var tui_cnt = 0
	for tui in my_hand: #tuis in hand - by array
		var new_tui = tui_scene.instantiate() #tui in hand - by object
		add_child(new_tui)
		var image_name = Gvar.player_hand["Player 1"][tui_cnt].name
		new_tui.name = image_name + str(tui_cnt+1)
		new_tui.position = Vector2(center_screen_x,center_screen_y) # set center
		node_mapping[new_tui] = tui
		tui_cnt += 1
		var sprite2D_node = new_tui.get_child(0)
		sprite2D_node.texture = load(tui_skin_path+Gvar.tui_skin_name[image_name]+".png")
	handfull_flag = true

func connect_tui_signals(tui):
	tui.connect("hover_on", on_hovered_over_card)
	tui.connect("hover_off", on_hovered_off_card)
	
func on_hovered_over_card(tui):
	if !hovering_tui_flag:
		hovering_tui_flag = true
		highligh_tui(tui,true)
	
func on_hovered_off_card(tui):
	highligh_tui(tui,false)
	var new_card_hovered = raycast_check_for_tui()
	if new_card_hovered:
		highligh_tui(new_card_hovered,true)
	else:
		hovering_tui_flag = false
	
func raycast_check_for_tui():
	var space_state = get_world_2d().direct_space_state
	var params = PhysicsPointQueryParameters2D.new()
	params.position = get_global_mouse_position()
	params.collide_with_areas = true
	params.collision_mask = COLLISION_MASK_TUI
	var result = space_state.intersect_point(params)
	if result.size() > 0:
		return result[0].collider.get_parent()
	else:
		return null
	
func highligh_tui(tui, hovered):
	if hovered:
		tui.scale = Vector2(TUI_HIGHLIGHT_SCALE,TUI_HIGHLIGHT_SCALE)
		tui.z_index = 2
	else:
		tui.scale = Vector2(TUI_DEFAULT_SCALE,TUI_DEFAULT_SCALE)
		tui.z_index = 1

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.is_pressed():
			var tui = raycast_check_for_tui()
			if tui:
				click_tui(tui)
		else:
			print("Left Click Release")

func click_tui(tui):
	selected_tui = tui
	var linked_tui = node_mapping.get(selected_tui)
	var new_position = Vector2(0,0)
	if selected_tui:
		tui.scale = Vector2(TUI_DEFAULT_SCALE,TUI_DEFAULT_SCALE)
		if selected_tui.selected_flag:
			play_slot.erase(linked_tui)
			my_hand.append(linked_tui)
			selected_tui.selected_flag = false
			new_position = Vector2(selected_tui.position.x, HAND_Y_POSITION)
			animate_tui_to_position(selected_tui,new_position,SELECTION_SPEED)
			print("my_hand = ",my_hand.size())
			print("play_slot = ",play_slot.size())
		else:
			my_hand.erase(linked_tui)
			play_slot.append(linked_tui)
			selected_tui.selected_flag = true
			new_position = Vector2(selected_tui.position.x, HAND_Y_POSITION - 20)
			animate_tui_to_position(selected_tui,new_position,SELECTION_SPEED)
			print("my_hand = ",my_hand.size())
			print("play_slot = ",play_slot.size())

func animate_tui_to_position(tui, new_position,speed):
	var tween = get_tree().create_tween()
	tween.tween_property(tui, "position", new_position, speed)

func update_hand_position() -> void:
	for i in range(my_hand.size()):
		var new_position = Vector2(calculate_tui_hand_position(i), HAND_Y_POSITION)
		var tui = get_child(i)
		animate_tui_to_position(tui,new_position,REPOSITION_SPEED)

func calculate_tui_hand_position(index) -> float:
	var total_width = (my_hand.size() - 1) * TUI_WIDTH
	var x_offset = center_screen_x + (index * TUI_WIDTH) - (total_width / 2)
	return x_offset
