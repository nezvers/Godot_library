extends Node

signal window_focus_changed

var in_focus: = false
var temp_focus: = false

func _ready()->void:
	get_tree().auto_accept_quit = false

func _notification(what:int)->void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_OUT:
			in_focus = false
			temp_focus = in_focus
			window_focus_changed.emit()
		NOTIFICATION_APPLICATION_FOCUS_IN:
			temp_focus = true
			await get_tree().process_frame
			if !temp_focus:
				return
			in_focus = true
			window_focus_changed.emit()
		NOTIFICATION_WM_CLOSE_REQUEST:
			get_tree().quit()
