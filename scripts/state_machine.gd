class_name MyStateMachine
extends Node

@export_node_path("MyState") var initial_state: NodePath

var current_state: MyState
var npc: Node3D

func _ready() -> void:
	assert(initial_state)
	current_state = null
	npc = self.owner

	var init_state: MyState = get_node(initial_state) as MyState
	switch_state(init_state)


func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)


func switch_state(new_state: MyState) -> void:
	assert(new_state)
	if current_state:
		current_state.exit(new_state)
	var old_state: MyState = current_state
	current_state = new_state
	current_state.state_machine = self
	current_state.npc = npc
	current_state.enter(old_state)
