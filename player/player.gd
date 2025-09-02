extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var health = 5
var status = "alive"

var currentProjectileScene


func _ready() -> void:
	$Sprite.scale.y = 3 + sqrt(2)
	$Collision.scale.y = sqrt(2)
	$ProgressBarViewport/ProgressBar.value = health


func _physics_process(delta: float) -> void:
	if status == "dead":
		print("YOU DIED.")
		return



	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("Space") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var move_input_dir := Input.get_vector("A", "D", "W", "S")
	var aim_input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	var direction := (transform.basis * Vector3(move_input_dir.x, 0, move_input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)



	$RayCast.target_position.x = aim_input_dir.x
	$RayCast.target_position.z = aim_input_dir.y

	$Reticle.modulate.a = abs($Reticle.position.x) + abs($Reticle.position.z)

	if $RayCast.is_colliding():
		$Reticle.position = lerp($Reticle.position, to_local($RayCast.get_collision_point()), delta * 20)
	else:
		$Reticle.position = lerp($Reticle.position, $RayCast.target_position, delta * 20)



	if Input.is_action_just_pressed("R"):
		position = Vector3(0,3,0)



	if Input.is_action_just_pressed("1"):
		currentProjectileScene = preload("res://projectiles/projectile_test.tscn")
	elif Input.is_action_just_pressed("2"):
		currentProjectileScene = preload("res://projectiles/projectile_starter.tscn")

	if Input.is_action_just_pressed("LAlt") and currentProjectileScene:
		var projectileInstance = currentProjectileScene.instantiate()
		projectileInstance.hurt = "Enemy"
		projectileInstance.shot_dir = to_global($RayCast.target_position)
		projectileInstance.global_position = self.global_position
		add_sibling(projectileInstance)
		print("sent projectile")



	move_and_slide()



func damage(damage: int):
	if health >= 0:
		health -= damage
		$ProgressBarViewport/ProgressBar.value = health
	if health == 0:
		die()
		print("PLAYER DIED")

func die():
	status = "dead"
