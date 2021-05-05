extends KinematicBody2D

var velocity = Vector2(0, 0)
var poke_vector = Vector2(0, 0)
var windspeed = Vector2(0, 0)

const GLIDE_DRAG = 0.04
const STALL_DRAG = 0.3
const SPEED = 100
const GRAV = 20
const GLIDE_DOWN_SPEED = 60
const JUMPFORCE = -300
const POKEFORCE = -200
const FRICTION = 0.2


func _ready():
	play("idle")

func play(animation, flip_h=null, flip_v=null):
	if flip_h != null:
		$PlayerSprite.flip_h = flip_h
		$Parasol/ParasolSprite.flip_h = flip_h
	if flip_v != null:
		$PlayerSprite.flip_v = flip_v
		$Parasol/ParasolSprite.flip_v = flip_v
	if($AnimationPlayer.current_animation == animation):
		return
	$AnimationPlayer.play(animation)

# warning-ignore:unused_argument
func _physics_process(delta):
	var button_pressed = false
	var left_right_pressed = "no"
	var up_down_pressed = "no"
	var max_down_speed = INF
	var gliding = false
	var stalling = false

	# TODO move poke force into poke block
	# TODO increase up and down force for diagional pokes
	if Input.is_action_pressed("glide"):
		max_down_speed = GLIDE_DOWN_SPEED
		gliding = true
		play("glide")
	if Input.is_action_pressed("stall"):
		stalling = true
		play("stall")
	if Input.is_action_pressed("ui_right"):
		button_pressed = true
		left_right_pressed = "right"
		if is_on_floor() or gliding:
			velocity.x = SPEED
		poke_vector.x = POKEFORCE
		if !Input.is_action_just_pressed("poke") and is_on_floor():
			play("run", false)
	if Input.is_action_pressed("ui_left"):
		button_pressed = true
		left_right_pressed = "left"
		if is_on_floor() or gliding:
			velocity.x = -SPEED
		poke_vector.x = -POKEFORCE
		if !Input.is_action_just_pressed("poke") and is_on_floor():
			play("run", true)
	if Input.is_action_pressed("ui_up"):
		button_pressed = true
		up_down_pressed = "up"
		poke_vector.y = -POKEFORCE
	if Input.is_action_pressed("ui_down"):
		button_pressed = true
		up_down_pressed = "down"
		poke_vector.y = POKEFORCE
	if Input.is_action_just_pressed("poke"):
		var poke_animations = {
			"up": { "left": "poke_ul", "right": "poke_ur", "no": "poke_u" },
			"down": { "left": "poke_dl", "right": "poke_dr", "no": "poke_d" },
			"no": { "left": "poke_l", "right": "poke_r", "no": "none" }
		}
		var poke_animation = poke_animations[up_down_pressed][left_right_pressed]
		if poke_animation != "none":
			# Only consider the poke a button press if acompanied by a direction
			button_pressed = true
			play(poke_animation)

	if is_on_floor() and !button_pressed:
		poke_vector = Vector2(0, 0)
		play("idle")

	velocity.y += GRAV
	velocity.y = min(velocity.y, max_down_speed)
	
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMPFORCE
		play("jump")
	
	velocity = move_and_slide(velocity, Vector2.UP)
	 
	# lerp with friction when on floor, wind and glide/stall when in the air
	if is_on_floor():
		velocity.x = lerp(velocity.x, 0, FRICTION)
	elif gliding:
		velocity.x = lerp(velocity.x, windspeed.x, GLIDE_DRAG)
	elif stalling:
		velocity.x = lerp(velocity.x, windspeed.x, STALL_DRAG)

# warning-ignore:unused_argument
func _on_FallZone_body_entered(body):
# warning-ignore:return_value_discarded
	get_tree().change_scene("Main.tscn")

# When the parasol collides with something
# warning-ignore:unused_argument
func _on_Parasol_body_entered(body):
	print("parasol_body_entered: ", body, poke_vector)
	velocity += poke_vector


func _on_Parasol_area_entered(area):
	_on_Parasol_body_entered(area)


func _on_Parasol_area_shape_entered(area_id, area, area_shape, self_shape):
	_on_Parasol_body_entered(area_shape)
