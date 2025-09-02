extends Area3D

@export_enum('Player', 'Enemy') var hurt = 'Enemy'
@export var damage = 1
var shot_dir


func _ready() -> void:
	look_at(shot_dir)
	rotate_y(deg_to_rad(180))

func _process(delta: float) -> void:
	translate(Vector3(0,0, delta * 5))


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(hurt):
		body.damage(damage)
		self.queue_free()
	if body.is_in_group('Terrain'):
		self.queue_free()
