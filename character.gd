extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -500.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var sprite_2d = $Sprite2D
@onready var camera_2d = $"../Camera2D"
var left_boundary = 570
var right_boundary = 1010
@onready var enemy = $"../Enemy"
@onready var item = $"../Checkpoint"
@onready var trophy = $"../Trophy"
@onready var all_interactions = []
@onready var interact_label = $Interaction/Label
var interaction_occurred = false

func _ready():
	update_interaction()
	trophy.visible = false

func _physics_process(delta):
	if (velocity.x > 1 || velocity.x < -1):
		sprite_2d.animation = "run"
	else:
		sprite_2d.animation = "idle"
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		sprite_2d.animation = "jump"

	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if Input.is_action_just_pressed("interact"):
		execute_interaction()
		
	if Input.is_action_just_pressed("shift"):
		var temp_x1 = enemy.global_position.x
		var temp_y1 = enemy.global_position.y
		var temp_x2 = global_position.x
		var temp_y2 = global_position.y
		enemy.global_position.x = temp_x2
		enemy.global_position.y = temp_y2
		global_position.x = temp_x1
		global_position.y = temp_y1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 50)

	move_and_slide()
	
	var isLeft = velocity.x < 0
	sprite_2d.flip_h = isLeft
	
	if camera_2d:
		var target_position = global_position
		var camera_position = camera_2d.global_position
		camera_position.x = clamp(target_position.x, left_boundary, right_boundary)
		camera_2d.global_position = camera_position

func _on_interaction_area_area_entered(area):
	all_interactions.insert(0, area)
	update_interaction()

func _on_interaction_area_area_exited(area):
	all_interactions.erase(area)
	update_interaction()

func update_interaction():
	if all_interactions:
		interact_label.text = all_interactions[0].item_label
	else:
		interact_label.text = ""
		
func execute_interaction():
	if all_interactions and not interaction_occurred:
		item.queue_free()
		trophy.visible = true
		trophy.item_label = "You Win !!!"
		interaction_occurred = true
