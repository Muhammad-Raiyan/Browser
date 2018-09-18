extends Tabs
# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.connect("tab_changed", self, "_on_tab_changed")
	self.connect("tab_close", self, "_on_tab_close") 
	set_tab_close_display_policy(CLOSE_BUTTON_SHOW_ALWAYS)

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass


func _on_tab_changed(idx):
	print("idx: " + str(idx) + " Token: " + str(get_child_count()))
	pass;
	
func _on_tab_close(idx):
	remove_tab(idx)
	pass;
