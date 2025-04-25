class_name MyShelf
extends Node3D

@export var initial_item: PackedScene

@onready var marker_3d: Marker3D = $Marker3D
@onready var models_exclamation: MeshInstance3D = $ModelsExclamation

var current_item: MyHoldableItem


func _ready() -> void:
	if initial_item:
		current_item = initial_item.instantiate()
		marker_3d.add_child(current_item)
		current_item.position = Vector3.ZERO
		models_exclamation.visible = false
	else:
		current_item = null
		models_exclamation.visible = true


func swap_item(hand: Marker3D, in_hand: MyHoldableItem) -> MyHoldableItem:
	var on_shelf: MyHoldableItem = current_item

	if in_hand:
		in_hand.reparent(marker_3d, false)
		in_hand.position = Vector3.ZERO

	if current_item:
		current_item.reparent(hand, false)
		current_item.position = -current_item.handle.position

	current_item = in_hand
	models_exclamation.visible = (current_item == null)
	return on_shelf
