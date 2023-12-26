extends CharacterBody3D


@export var JUMP_VELOCITY = 200
@export var ACCELERATION = 4.0
@export var mouse_sens = 0.05
@export var weight = 10.0
@export var traction = 2.0
  
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var jumping = false 

@onready var spring_arm = $SpringArm3D
@onready var model = $fish
#@onready var anim_tree = $fish/AnimationTree
#@onready var anim_state = $fish/AnimationTree.get("parameters/playback")
@onready var anim_player = $fish/AnimationPlayer


func _physics_process(delta):
	velocity.y += -gravity * delta * 20
	get_move_input(delta)
	#anim_tree["parameters/conditions/idle"] = true
	anim_player.play("flop_in_place_2")
	
	move_and_slide()
	
func get_move_input(delta):
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, spring_arm.rotation.y)
	velocity += ACCELERATION * dir
	if is_on_floor():
		var friction = -1 * velocity.normalized() * traction
		if (velocity - friction).normalized() == -1 * velocity.normalized():
			velocity = Vector3.ZERO
		else:
			velocity += friction
	  
		
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm.rotation.x -= event.relative.y * mouse_sens
		spring_arm.rotation_degrees.x = clamp(spring_arm.rotation_degrees.x, -90, 30)
		spring_arm.rotation.y -= event.relative.x * mouse_sens
	if event.is_action_pressed("jump"):
		if is_on_floor():
			velocity.y += JUMP_VELOCITY
		
		
