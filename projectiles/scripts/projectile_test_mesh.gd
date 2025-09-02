extends MeshInstance3D


func _ready() -> void:
	rotation = Vector3(randi(), randi(), randi())

func _process(delta: float) -> void:
	rotate_z(deg_to_rad(3))
