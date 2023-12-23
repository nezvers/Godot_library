## Save / Load audio bus layout & take care of volume manipulation
class_name AudioSettingsResource
extends SaveableResource

@export var audio_bus_layout:AudioBusLayout

func set_audo_bus_layout()->void:
	AudioServer.set_bus_layout(audio_bus_layout)

## Override function for resetting to default values
func reset_resource()->void:
	set_audo_bus_layout()

## Override for creating data Resource that will be saved with the ResourceSaver
func prepare_save()->Resource:
	var data:AudioSettingsResource = self.duplicate()
	data.audio_bus_layout = audio_bus_layout.duplicate()
	return data

## Override to ad logic for reading loaded data and applying to current instance of the Resource
func prepare_load(data:Resource)->void:
	audio_bus_layout = data.audio_bus_layout
	set_audo_bus_layout()

func set_bus_volume(bus:StringName, volume:float)->void:
	var idx: = AudioServer.get_bus_index(bus)
	if idx == -1:
		print("AudioSettingsResource: ERROR - setting non existing audio bus [", bus, "]")
		return
	var db:float = linear_to_db(volume)
	#print(bus, " ", volume, " ", db)
	db = clamp(db, -80.0, +24.0)
	AudioServer.set_bus_volume_db(idx, db)

func get_bus_volume(bus:StringName)->float:
	var idx: = AudioServer.get_bus_index(bus)
	if idx == -1:
		print("AudioSettingsResource: ERROR - getting non existing audio bus [", bus, "]")
		return 0.0
	var db:float = AudioServer.get_bus_volume_db(idx)
	var volume:float = db_to_linear(db)
	return volume
