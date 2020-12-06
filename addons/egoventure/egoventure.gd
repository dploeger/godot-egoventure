tool
extends EditorPlugin

var editor_dock: MapDock
var editor_button: ToolButton
var editor_selection = get_editor_interface().get_selection()

func _enter_tree():
	editor_dock = preload("res://addons/egoventure/scenes/MapDock.tscn").instance()
	editor_button = add_control_to_bottom_panel(editor_dock, "Map")
	set_editor_button_visible(false)
	get_tree().connect("node_added", self, "_on_tree_node_added")
	editor_selection.connect("selection_changed", self, "_on_editor_selection_changed")

func _exit_tree():
	remove_custom_type("Map")
	remove_control_from_bottom_panel(editor_dock)
	editor_dock.queue_free()
	
func _on_tree_node_added(node: Node):
	pass

func _on_editor_selection_changed():
	var selected_nodes = editor_selection.get_selected_nodes()
	
	if selected_nodes.size() == 1 and selected_nodes[0] is Map and (selected_nodes[0] as Map).map_resource != null:
		set_editor_button_visible(true)
		editor_dock.set_map(selected_nodes[0])
	
func set_editor_button_visible(visible: bool):
	editor_button.visible = visible
