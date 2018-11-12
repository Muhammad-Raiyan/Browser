extends TabContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
func _ready():
	self.connect("tab_changed", self, "_on_tab_changed")
	
	add_new_tab()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_new_tab():
	
	var new_tab_node = Control.new()
	new_tab_node.set_name("TabNode")
	new_tab_node.size_flags_vertical = SIZE_EXPAND_FILL
	
	
	var debugTexLabel = RichTextLabel.new()
	debugTexLabel.set_name("debugTexLabel")
	debugTexLabel.add_text("Debug Text")
	debugTexLabel.margin_right = 100
	debugTexLabel.margin_bottom = 100
	new_tab_node.add_child(debugTexLabel)
	
	add_child(new_tab_node)
	
	var index = get_tab_count()-1
	current_tab = index
	
	return index


func _on_tab_changed(idx):
	var tab_container = get_tree().get_root().get_node("Control/VBoxContainer/TabContainer")
	print("container_tab_id: " + str(idx))
	#tab_container.current_tab = idx
	pass;
	
func _on_tab_close(idx):
	remove_child(get_tab_control(idx))
	
