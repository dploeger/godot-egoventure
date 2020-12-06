tool
class_name MapDock
extends Control

var map: Map
var map_editor: GraphEdit

func _ready():
	$Layout/Toolbar/New.get_popup().connect("id_pressed", self, "_new_menu_pressed")

func _new_menu_pressed(id):
	if id == 0:
		add_four_panorama_room()

func set_map(p_map: Map):
	map = p_map
	for child in $Layout/MapContainer.get_children():
		$Layout/MapContainer.remove_child(child)
	$Layout/MapContainer.add_child(map.get_map())
	map_editor = $Layout/MapContainer.get_children()[0]
	map_editor.connect("connection_request", self, "_connect_room")
	map_editor.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_editor.anchor_right = 1
	map_editor.anchor_bottom = 1
	
func save():
	print_debug("Saving map")
	map.set_map(map_editor)
	
func _remove_room(node: Room):
	print_debug("Removing room %s" % node.title)
	map_editor.remove_child(node)
	save()
	
func _resize_room(new_minsize: Vector2, node: Room):
	print_debug("Resizing room %s" % node.title)
	node.rect_size = new_minsize
	save()
	
func _connect_room(from: String, from_slot: int, to: String, to_slot: int):	
	var room_from = map_editor.find_node(from) as Room
	var room_to = map_editor.find_node(to) as Room
	print_debug("Connecting room %s (%d) to room %s (%d)" % [room_from.title, from_slot, room_to.title, to_slot])
	map_editor.connect_node(from, from_slot, to, to_slot)
	save()

func add_four_panorama_room():
	print_debug("Adding new four panorama room")
	var node = preload("res://addons/egoventure/nodes/FourPanoramaRoom.tscn").instance()
	map_editor.add_child(node)
	node.owner = map_editor
	node.connect("close_request", self, "_remove_room", [node])
	node.connect("resize_request", self, "_resize_room", [node])
	save()
