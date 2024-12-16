extends Node2D

@export var selected_flag : bool = false

signal hover_on
signal hover_off

var hover_flag = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_parent().connect_tui_signals(self)
	hover_flag = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_mouse_entered() -> void:
	emit_signal("hover_on", self)
	hover_flag = true

func _on_area_2d_mouse_exited() -> void:
	emit_signal("hover_off", self)
	hover_flag = false
