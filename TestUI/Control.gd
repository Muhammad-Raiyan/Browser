extends Control

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var tab_token_count = 0;
# Called when the node enters the scene tree for the first time.
func _ready():
	_on_add_tab_Button_pressed()
	#get_node("VBoxContainer/TabNode").print_tree()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload_page"):
		print("reload page")
		#print_tree()
#		for c in tab_node.get_children():
#			print(c.get_name())
	pass


func _on_add_tab_Button_pressed():
	var tabs = get_node("VBoxContainer/TabPanelHBox/Tabs")
	tab_token_count = tab_token_count + 1;
	tabs.add_tab("New Tab")
	
#	var text_label = RichTextLabel.new()
#	#text_label.add_color_override("font_color", Color(0,0,0,0))
#	text_label.set_name("TextLabel")
#	text_label.add_text("Info:")
#	text_label.size_flags_vertical = SIZE_EXPAND_FILL
#	text_label.size_flags_horizontal = SIZE_EXPAND_FILL
#
##	text_label.rect_position = Vector2(10, 10)
##	text_label.rect_size = Vector2(200, 200)
#
#	var text_label2 = RichTextLabel.new()
#	#text_label2.add_color_override("font_color", Color(0,0,0,0))
#	text_label2.set_name("TextLabel2")
#	text_label2.add_text("Info2:")
#	text_label2.size_flags_vertical = SIZE_EXPAND_FILL
#	text_label2.size_flags_horizontal = SIZE_EXPAND_FILL
##	text_label2.rect_position = Vector2(500, 200)
##	text_label2.rect_size = Vector2(200, 200)
	
	var new_tab_node = VBoxContainer.new()
	new_tab_node.set_name("TabNode")
	new_tab_node.modulate = Color(0,0,0,1)
	new_tab_node.size_flags_vertical = SIZE_EXPAND_FILL
	#new_tab_node.add_color_override("font_color", Color(0,0,0,0))
#	new_tab_node.add_child(text_label)
#	new_tab_node.add_child(text_label2)
	
	var container = get_node("VBoxContainer")
	container.add_child(new_tab_node)
	#container.add_color_override("font_color", Color(0,0,0,0))
	#get_node("VBoxContainer").add_child(
