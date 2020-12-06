tool
class_name Map, "res://addons/egoventure/icons/map.svg"
extends Node

export(PackedScene) var map_resource

func get_map():
	if map_resource == null or ! map_resource.can_instance():
		print_debug("Creating a new map because saved resource is empty or can not be instantiated")
		map_resource = PackedScene.new()
		return GraphEdit.new()
	else:
		print_debug("Instantiating saved resource and returning map")
		return map_resource.instance()
	
func set_map(p_map: GraphEdit):
	print_debug("Packing map")
	map_resource.pack(p_map)

func _ready():
	pass	
