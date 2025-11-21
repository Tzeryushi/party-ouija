class_name Processor
extends Node

## Handles some environmental changes.

@export var light_array: Array[OmniLight3D]
@export var flame_particles: Array[GPUParticles3D]

@export var normal_light_color: Color
@export var angry_light_color: Color
@export var calm_light_color: Color
@export var wide_light_range: float = 100.0

@onready var base_light_energy: float = light_array[0].light_energy
@onready var base_light_range: float = light_array[0].omni_range

var is_angry: bool = false


func change_light_color(new_color: Color) -> void:
	for light in light_array:
		if light is OmniLight3D:
			light.light_color = new_color
	
	var flame_gradient = get_flame_gradient(new_color)
	for flame in flame_particles:
		if flame is GPUParticles3D:
			var process_mat: ParticleProcessMaterial = flame.process_material
			process_mat.color_ramp = flame_gradient


func change_light_radius(new_radius: float) -> void:
	for light in light_array:
		if light is OmniLight3D:
			light.omni_range = new_radius


func get_flame_gradient(color: Color) -> GradientTexture1D:
	var grad_tex: GradientTexture1D = GradientTexture1D.new()
	grad_tex.gradient = Gradient.new()
	grad_tex.gradient.set_color(0, color)
	grad_tex.gradient.set_color(1, Color(0,0,0,0))
	return grad_tex


func _on_angry_triggered() -> void:
	change_light_color(angry_light_color)
	change_light_radius(wide_light_range)


func _on_calm_triggered() -> void:
	change_light_color(normal_light_color)
	change_light_radius(base_light_range)


func _on_decider_decided(_answer: String, has_trauma: bool) -> void:
	if has_trauma:
		_on_angry_triggered()
		is_angry = true


func _on_ouija_board_answer_complete() -> void:
	if is_angry:
		_on_calm_triggered()
		is_angry = false
