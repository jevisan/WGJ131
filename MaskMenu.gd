extends CanvasLayer

onready var itemlist = $ItemList

var last_added_index = 0

signal mask_selected

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

func _on_PickableMaskShield_picked(mask):
	_add_mask_icon("res://assets/mask-icons/Mask_64x64-1.png", mask)
	itemlist.set_item_metadata(last_added_index-1, {"name":"shield"})

func _on_PickableMaskDash_picked(mask):
	_add_mask_icon("res://assets/mask-icons/Mask_64x64-2.png", mask)
	itemlist.set_item_metadata(last_added_index-1, {"name":"dash"})

func _on_PickableMaskAttack_picked(mask):
	_add_mask_icon("res://assets/mask-icons/Mask_64x64-4.png", mask)
	itemlist.set_item_metadata(last_added_index-1, {"name":"attack"})

func _add_mask_icon(icon, mask):
	var img = Image.new()
	var itex = ImageTexture.new()
	img.load(icon)
	itex.create_from_image(img)
	itemlist.add_icon_item(itex)
	last_added_index += 1
