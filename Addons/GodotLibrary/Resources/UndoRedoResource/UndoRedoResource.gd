extends Resource
class_name UndoRedoResource

class MethodCall:
	var object:Object
	var method:StringName
	var args:Array
	func _init(_object:Object, _method_name:StringName, _args:Array):
		object = _object
		method = _method_name
		args = _args

class UndoRedoAction:
	var name:String
	var do_methods:Array[Callable]
	var undo_methods:Array[Callable]
	var do_methodcalls:Array[MethodCall]
	var undo_methodcalls:Array[MethodCall]
	
	func _init(action_name:String)->void:
		name = action_name
	
	func do()->void:
		for callable in do_methods:
			callable.call()
		for methodcall in do_methodcalls:
			methodcall.object.call(methodcall.method, methodcall.args)

	func undo()->void:
		for callable in do_methods:
			callable.call()
		for methodcall in undo_methodcalls:
			methodcall.object.call(methodcall.method, methodcall.args)

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

func add_do_methodcall(object:Object, method_name:StringName, args:Array)->void:
	assert(current_action != null, "No current action")
	current_action.do_methodcalls.append(MethodCall.new(object, method_name, args))

func add_undo_methodcall(object:Object, method_name:StringName, args:Array)->void:
	assert(current_action != null, "No current action")
	current_action.undo_methodcalls.append(MethodCall.new(object, method_name, args))

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
	action_list[index].undo()

func redo()->void:
	if  !has_redo():
		return
	action_list[index].do()
	index += 1

