extends Node3D

var time_passed: float = 0.0


func _ready() -> void:
	randomize()

	
func _process(delta: float) -> void:
	time_passed += delta*0.1
	$Environment/DirectionalLight3D.rotation.y = 0.3*sin(time_passed)
