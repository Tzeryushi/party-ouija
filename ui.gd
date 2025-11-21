extends Control

## Handles input and output of responses in text.

## ResponseContainer contains a set of labels, each is a separate letter in the
## answer. A separate set of letters uses these label locations as base positions
## but are animated with noise around them. This is so we can use the hbox for
## relatively dynamic positioning.

@export var text_input: LineEdit
@export var response_container: HBoxContainer
@export var letters_node: Control
@export var letter_scene: PackedScene
@export var communication_text: RichTextLabel

signal submitted(text: String)

var prompt_fade_tween: Tween


func _ready() -> void:
	clear_text()
	text_input.grab_focus()
	text_input.grab_click_focus()
	text_input.edit()


func add_text(text: String) -> void:
	var letter_label: Letter = letter_scene.instantiate()
	letter_label.update_text(text)
	letter_label.modulate.a = 0.0
	var display_letter: Letter = letter_label.duplicate()
	response_container.add_child(letter_label)
	letters_node.add_child(display_letter)
	display_letter.set_mirror(letter_label)
	display_letter.global_position = get_viewport_rect().size/2.0
	display_letter.fade_to_destination()


func clear_text() -> void:
	for child in response_container.get_children():
		response_container.remove_child(child)
		child.queue_free()
	for child in letters_node.get_children():
		if child is Letter:
			child.fade_to_free()


func fade_prompt(value: float = 0) -> void:
	if prompt_fade_tween and prompt_fade_tween.is_running():
		prompt_fade_tween.kill()
	prompt_fade_tween = create_tween()
	prompt_fade_tween.tween_property(communication_text, "modulate:a", value, 1.0).set_ease(
		Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)


func _on_text_input_text_submitted(new_text: String) -> void:
	## Clear out text and emit signal with submission
	if text_input.text.is_empty():
		text_input.grab_focus()
		text_input.grab_click_focus()
		text_input.call_deferred("edit")
		return
	
	clear_text()
	submitted.emit(new_text)
	text_input.editable = false
	text_input.clear()
	fade_prompt(0.0)


func _on_ouija_board_answer_complete() -> void:
	text_input.editable = true
	text_input.grab_focus()
	text_input.grab_click_focus()
	text_input.edit()
	fade_prompt(1.0)


func _on_ouija_board_moved(text: String) -> void:
	add_text(text)


func _on_pause_menu_closed() -> void:
	if text_input.editable:
		text_input.grab_focus()
		text_input.grab_click_focus()
		text_input.call_deferred("edit")
