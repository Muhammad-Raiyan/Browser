extends Control

# Declare member variables here. Examples:
var tab_tokens = [0]
var tab_token = -1

onready var tabs = get_node("VBoxContainer/TabPanelHBox/Tabs")
onready var tab_container = get_node("VBoxContainer/TabContainer")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload_page"):
		print(tab_tokens)
		#get_node("VBoxContainer/TabNode").print_tree()
		#getallnodes(get_node("VBoxContainer/TabNode"))
	pass


func _on_add_tab_Button_pressed():
	
	var tab_id= tabs.add_new_tab()
	var container_tab_id = tab_container.add_new_tab()
	
	tab_tokens.append(tab_id)
	print("tab_id: " + str(tab_id) + " container_tab_id: " + str(container_tab_id))


func close_browser():
	print("Closing browser")
	#OS.kill(pid)
	get_node("/root").get_tree().quit()
	#get_tree().get_root().quit()

func getallnodes(node):
    for N in node.get_children():
        if N.get_child_count() > 0:
            print("["+N.get_name()+ ", " + N.get_class() +"]")
            getallnodes(N)
        else:
            # Do something
            print("- "+N.get_class())

