extends CanvasLayer

onready var itemlist = $ItemList

var last_added_index = 0

signal mask_selected(mask)

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_select"):
		itemlist.grab_focus()
	elif event.is_action_released("ui_select"):
		itemlist.release_focus()

func _on_ItemList_item_selected(index):
	var mask_name = itemlist.get_item_metadata(index)["name"]
	emit_signal("mask_selected", mask_name)

func _on_PickableMask_picked(mask):
	var mask_file
	var mask_name
	match mask:
		"PickableMaskShield":
			mask_file = "Mask_64x64-1.png"
			mask_name = "shield"
		"PickableMaskAttack":
			mask_file = "Mask_64x64-4.png"
			mask_name = "attack"
		"PickableMaskDash":
			mask_file = "Mask_64x64-2.png"
			mask_name = "dash"
	_add_mask_icon("res://assets/mask-icons/" + mask_file, mask)
	itemlist.set_item_metadata(last_added_index-1, {"name": mask_name})

func _add_mask_icon(icon, mask):
	itemlist.add_icon_item(load(icon))
	last_added_index += 1
