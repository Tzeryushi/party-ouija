extends CanvasLayer

signal menu_closed


func _ready() -> void:
	visible = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu"):
		visible = !visible
		if not visible:
			menu_closed.emit()


func _on_full_screen_button_pressed() -> void:
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_return_button_pressed() -> void:
	visible = !visible
	if not visible:
		menu_closed.emit()


func _on_exit_button_pressed() -> void:
	get_tree().quit()
