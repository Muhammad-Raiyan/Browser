extends TabContainer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.
onready var mainControl = get_tree().get_root().get_node("Control")

func _ready():
	self.connect("tab_changed", self, "_on_tab_changed")
	
	add_new_tab()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_new_tab():
	var new_tab_node = Control.new()
	new_tab_node.set_name("TabNode")
	new_tab_node.size_flags_vertical = SIZE_EXPAND_FILL
	
	
	var scroll_container = ScrollContainer.new()
	scroll_container.anchor_bottom = 1
	scroll_container.anchor_right = 1
	scroll_container.scroll_horizontal_enabled = false
	
	var vbox = VBoxContainer.new()
	vbox.set_alignment(BoxContainer.ALIGN_BEGIN)
	vbox.anchor_right = 1
	vbox.anchor_bottom = 1
	vbox.size_flags_horizontal = SIZE_EXPAND_FILL
	
	scroll_container.add_child(vbox)
	new_tab_node.add_child(scroll_container)
	
	
	add_child(new_tab_node)
	var index = get_tab_count()-1
	current_tab = index
	
	return index


func _on_tab_changed(idx):
	mainControl.clear_url_bar()
	mainControl.set_url(idx)
	print("container_tab_id: " + str(idx))
	
	
func _on_tab_close(idx):
	remove_child(get_tab_control(idx))
	
func get_active_tab_id():
	return current_tab
	
func append_text(text):
	var infoLabel = get_current_tab_control().get_child(0)
	#infoLabel.newline()
	infoLabel.add_text(text)
	
func clear_page():
	var tab_vbox = get_current_tab_control().get_child(0).get_child(0)
	for i in range(0, tab_vbox.get_child_count()):
		tab_vbox.get_child(i).queue_free()
	
func add_text_label(text):
	var textLabel = Label.new()
	textLabel.text = text
	textLabel.anchor_right = 1
	textLabel.anchor_bottom = 1
	textLabel.set_autowrap(true)
	get_current_tab_control().get_child(0).get_child(0).add_child(textLabel)
	
	
	 
	

