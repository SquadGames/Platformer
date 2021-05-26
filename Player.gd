extends KinematicBody2D

const GROUND_SPEED = 150
const AIR_SPEED = 100
const GRAV = 2500
const JUMPFORCE = -400
const POKEFORCE = -450
const POKE_ACTIVE_TIME = 0.01
const BASE_AIR_FRICTION = 0.05
const BASE_GROUND_FRICTION = 0.2
const GLIDE_AIR_FRICTION = 1
enum State {
	READY,  # new actions possible
	ACTING, # no new actions until current action done
}
enum Direction {RIGHT, LEFT, NONE}

var velocity = Vector2(0, 0)
var poke_vector = Vector2(0, 0)
var horizontal_poke_factor = 0.4
var vertical_poke_factor = 1.0
var ground_friction = BASE_GROUND_FRICTION
var air_friction = BASE_AIR_FRICTION
var max_glide_down_speed = 30
var state = State.READY
var until_ready = 0
var wind_velocity = Vector2(0, 0)


func _ready():
	play("idle")


func play(animation):
	if($AnimationPlayer.current_animation == animation):
		return
	$AnimationPlayer.play(animation)


# TODO consider putting active/ready in the animation player
func active_for(active_time):
	until_ready = active_time
	state = State.ACTING


func face(direction):
	if direction == Direction.RIGHT:
		$PlayerSprite.flip_h = false
		$Parasol/ParasolSprite.flip_h = false
	else:
		$PlayerSprite.flip_h = true
		$Parasol/ParasolSprite.flip_h = true


func idle(delta):
	if !is_on_floor() \
		or Input.is_action_pressed("ui_left") \
		or Input.is_action_pressed("ui_right"):
		return

	play("idle")

	velocity.x = lerp(velocity.x, 0, ground_friction)


func jump(delta):
	if !Input.is_action_just_pressed("jump") or !is_on_floor():
		return

	play("jump")
	velocity.y += JUMPFORCE


func move(max_speed, lerp_weight, direction):
	if (velocity.x < max_speed and direction == Direction.LEFT):
		# moving left and velocity is already negative enough
		return

	if (velocity.x > max_speed and direction == Direction.RIGHT):
		# moving right and velocity is already high enough
		return

	face(direction)
	velocity.x = lerp(velocity.x, max_speed, lerp_weight)


func ground_move(delta):
	if !is_on_floor():
		return

	if Input.is_action_pressed("ui_right"):
		play("run")
		move(GROUND_SPEED, ground_friction, Direction.RIGHT)
	elif Input.is_action_pressed("ui_left"):
		play("run")
		move(-GROUND_SPEED, ground_friction, Direction.LEFT)


func air_move(delta):
	if is_on_floor():
		return

	if Input.is_action_pressed("ui_right"):
		move(AIR_SPEED, air_friction, Direction.RIGHT)
	elif Input.is_action_pressed("ui_left"):
		move(-AIR_SPEED, air_friction, Direction.LEFT)


func glide(delta):
	if !Input.is_action_pressed("glide"):
		air_friction = BASE_AIR_FRICTION
		return
	if is_on_floor():
		return

	play("glide")
	velocity.y = min(velocity.y, max_glide_down_speed)
	air_friction = GLIDE_AIR_FRICTION

	# TODO consider changing air speed rather than executing move again here
	if Input.is_action_pressed("ui_right"):
		move(AIR_SPEED, air_friction, Direction.RIGHT)
	elif Input.is_action_pressed("ui_left"):
		move(AIR_SPEED, air_friction, Direction.LEFT)


func gravity(delta):
	velocity.y += GRAV * delta


func poke_d(delta):
	if !Input.is_action_just_pressed("poke_d"):
		return

	poke_vector = Vector2(0, POKEFORCE)
	play("poke_d")
	active_for(POKE_ACTIVE_TIME)


func poke_dl(delta):
	if !Input.is_action_just_pressed("poke_dl"):
		return

	poke_vector = Vector2(-POKEFORCE, POKEFORCE)
	play("poke_dl")
	active_for(POKE_ACTIVE_TIME)


#func poke_l(delta):
#	if !Input.is_action_just_pressed("poke") \
#		or Input.is_action_pressed("ui_up") \
#  		or Input.is_action_pressed("ui_down") \
#		or !Input.is_action_pressed("ui_left") \
#		or Input.is_action_pressed("ui_right"):
#		return
#
#	poke_vector = Vector2(-POKEFORCE, 0)
#	play("poke_l")
#	active_for(POKE_ACTIVE_TIME)
#
#
#func poke_ul(delta):
#	if !Input.is_action_just_pressed("poke") \
#		or !Input.is_action_pressed("ui_up") \
#  		or Input.is_action_pressed("ui_down") \
#		or !Input.is_action_pressed("ui_left") \
#		or Input.is_action_pressed("ui_right"):
#		return
#
#	poke_vector = Vector2(-POKEFORCE, -POKEFORCE)
#	play("poke_ul")
#	active_for(POKE_ACTIVE_TIME)
#
#
#func poke_u(delta):
#	if !Input.is_action_just_pressed("poke") \
#		or !Input.is_action_pressed("ui_up") \
#  		or Input.is_action_pressed("ui_down") \
#		or Input.is_action_pressed("ui_left") \
#		or Input.is_action_pressed("ui_right"):
#		return
#
#	poke_vector = Vector2(0, -POKEFORCE)
#	play("poke_u")
#	active_for(POKE_ACTIVE_TIME)
#
#
#func poke_ur(delta):
#	if !Input.is_action_just_pressed("poke") \
#		or !Input.is_action_pressed("ui_up") \
#  		or Input.is_action_pressed("ui_down") \
#		or Input.is_action_pressed("ui_left") \
#		or !Input.is_action_pressed("ui_right"):
#		return
#
#	poke_vector = Vector2(POKEFORCE, -POKEFORCE)
#	play("poke_ur")
#	active_for(POKE_ACTIVE_TIME)
#
#
#func poke_r(delta):
#	if !Input.is_action_just_pressed("poke") \
#		or Input.is_action_pressed("ui_up") \
#  		or Input.is_action_pressed("ui_down") \
#		or Input.is_action_pressed("ui_left") \
#		or !Input.is_action_pressed("ui_right"):
#		return
#
#	poke_vector = Vector2(POKEFORCE, 0)
#	play("poke_r")
#	active_for(POKE_ACTIVE_TIME)

func wind(delta):
	if wind_velocity.x > 0:
		velocity.x = min(velocity.x,
			velocity.x + (wind_velocity.x * delta * air_friction))
	elif wind_velocity.x < 0:
		velocity.x = max(velocity.x,
			velocity.x + (wind_velocity.x * delta * air_friction))

	if wind_velocity.y > 0:
		velocity.y = min(velocity.y,
			velocity.y + (wind_velocity.y * delta * air_friction))
	elif wind_velocity.y < 0:
		print(velocity.y, " ", wind_velocity.y, " ", air_friction)
		velocity.y = min(velocity.y,
			velocity.y + (wind_velocity.y * delta * air_friction))
		print(velocity.y)

func poke_dr(delta):
	if !Input.is_action_just_pressed("poke_dr"):
		return

	poke_vector = Vector2(POKEFORCE, POKEFORCE)
	play("poke_dr")
	active_for(POKE_ACTIVE_TIME)


# warning-ignore:unused_argument
func _physics_process(delta):

	if state == State.READY:
		# Player actions
		idle(delta)
		jump(delta)
		ground_move(delta)
		air_move(delta)

		# future item actions
		glide(delta)
		poke_d(delta)
		poke_dl(delta)
		#poke_l(delta)
		#poke_ul(delta)
		#poke_u(delta)
		#poke_ur(delta)
		#poke_r(delta)
		poke_dr(delta)
	elif until_ready <= 0:
		until_ready = 0
		state = State.READY
	else:
		until_ready -= delta

	# Environment effects
	gravity(delta)
	wind(delta)

	# execute the movement
	velocity = move_and_slide(velocity, Vector2.UP)


# When the parasol collides with something
# warning-ignore:unused_argument
func _on_Parasol_body_entered(body):
	poke_vector.x *= horizontal_poke_factor
	poke_vector.y *= vertical_poke_factor
	velocity += poke_vector


func _on_wind_body_entered(body, vector):
	wind_velocity += vector
	print("Wind Entered: ", wind_velocity)

func _on_wind_body_exited(body, vector):
	wind_velocity -= vector
	print("Wind Exited: ", wind_velocity)
