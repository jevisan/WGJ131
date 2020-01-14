extends CanvasLayer

onready var itemlist = $ItemList
var current_selected = 0

signal mask_selected

func _ready():
	set_process_input(true)
	for i in range(3):
		var img = Image.new()
		var itex = ImageTexture.new()
		img.load("res://assets/mask.png")
		itex.create_from_image(img)
		itemlist.add_icon_item(itex)

func _input(event):
	if event.is_action_pressed("ui_select"):
		itemlist.grab_focus()
	elif event.is_action_released("ui_select"):
		itemlist.release_focus()

func _on_ItemList_item_selected(index):
	emit_signal("mask_selected", index)
