extends Resource
class_name UndoRedoResource

class UndoRedoAction:
	var name:String
	var do_methods:Array[Callable]
	var undo_methods:Array[Callable]
	
	func _init(action_name:String)->void:
		name = action_name

@export var undo_count: = 20

var action_list:Array[UndoRedoAction]
var current_action:UndoRedoAction
var index: = 0

func create_action(action_name:String)->void:
	current_action = UndoRedoAction.new(action_name)

func add_do_method(value:Callable)->void:
	assert(current_action != null, "No current action")
	current_action.do_methods.append(value)

func add_undo_method(value:Callable)->void:
	assert(current_action != null, "No current action")
	current_action.undo_methods.append(value)

# triggers redo action automatically
func commit_action()->void:
	assert(current_action != null, "No current action")
	action_list.resize(index) # clear previous redo
	action_list.append(current_action)
	current_action = null
	redo()
	
	if action_list.size() > undo_count:
		action_list.remove_at(0)
		index = action_list.size()

func has_redo()->bool:
	return index < action_list.size()

func has_undo()->bool:
	return index > 0

func undo()->void:
	if !has_undo():
		return
	index -= 1
	var action:UndoRedoAction = action_list[index]
	for callable in action.undo_methods:
		callable.call()

func redo()->void:
	if  !has_redo():
		return
	var action:UndoRedoAction = action_list[index]
	for callable in action.do_methods:
		callable.call()
	index += 1
