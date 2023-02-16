extends PopupMenu
class_name MenuPopupMenu

var callbacks:Dictionary = {}

func _ready()->void:
	index_pressed.connect(on_index_pressed)
	about_to_popup.connect(on_about_to_pop)

func on_index_pressed(i:int)->void:
	callbacks[i].call()

func submenu_popup(submenu:PopupMenu)->void:
	add_submenu_item(submenu.name, submenu.name)

func callback_button(item_name:String, callback:Callable)->void:
	var i: = item_count
	add_item(item_name)
	callbacks[i] = callback
	pass

func on_about_to_pop()->void:
	var parent: = get_parent()
	if !(parent is PopupMenu):
		return
	position.x = parent.position.x + parent.size.x
