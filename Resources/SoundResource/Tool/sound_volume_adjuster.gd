extends Control

@export var sound_resource_list:Array[SoundResource]

@export_group("Configuration")
@export var app_resolution:Vector2 = Vector2(1280, 720)

@export_group("References")
@export var name_label_container:Control
@export var value_label_container:Control
@export var slider_container:Control
@export var save_button:Button


func _ready()->void:
	get_tree().root.content_scale_size = app_resolution
	
	save_button.pressed.connect(save_sounds)
	
	for sound in sound_resource_list:
		add_sound(sound)
	
	set_value_column_width()


func add_sound(sound:SoundResource)->void:
	var name_label: = Label.new()
	name_label.text = sound.resource_path.get_file().get_basename()
	
	var value_label: = Label.new()
	
	var slider: = HSlider.new()
	slider.step = 0
	slider.max_value = 1
	slider.value = (sound.volume + 80) / 104.0
	slider.drag_ended.connect(slider_released.bind(slider, sound))
	slider.value_changed.connect(slider_value_changed.bind(value_label))
	slider_value_changed(slider.value, value_label)
	
	name_label_container.add_child(name_label)
	value_label_container.add_child(value_label)
	slider_container.add_child(slider)
	
	var max_height:float = max(name_label.size.y, slider.size.y)
	name_label.custom_minimum_size.y = max_height
	value_label.custom_minimum_size.y = max_height
	slider.custom_minimum_size.y = max_height

func set_value_column_width()->void:
	var temp_label: = Label.new()
	temp_label.text = "-00.00 " # extra space
	value_label_container.add_child(temp_label)
	
	await get_tree().process_frame
	value_label_container.custom_minimum_size.x = temp_label.size.x
	temp_label.queue_free()

func slider_released(_value_changed:bool, slider:HSlider, sound:SoundResource)->void:
	sound.volume = lerp(-80.0, +24.0, slider.value)
	sound.play_managed()


func slider_value_changed(value:float, label:Label)->void:
	value = lerp(-80.0, +24.0, value)
	label.text = str(round(value * 100.0) / 100.0)

func save_sounds()->void:
	for sound in sound_resource_list:
		ResourceSaver.save(sound, sound.resource_path)
		print("Saved: ", sound.resource_path.get_file().get_basename())
