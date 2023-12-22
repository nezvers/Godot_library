# AssetResource

Used to save paths to resources. If `file_path` is set it can be saved in user directory, then using `load_resource(force:bool = false)` load when needed. `force` is here to allow different situations where it's not known when is the first `resource_load` or `initialize` triggered. If in runtime you are not changing the content and resource is from project, then `load_resource` is not required. `initialize` is used to initialize `dictionary` holding filenames as keys.
