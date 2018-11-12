extends Control

# Declare member variables here. Examples:
var tab_tokens = [0]
var tab_token = -1

onready var tabs = get_node("VBoxContainer/TabPanelHBox/Tabs")
onready var tab_container = get_node("VBoxContainer/TabContainer")

var zmq
var pid

# Called when the node enters the scene tree for the first time.
func _ready():
	var dir = Directory.new()
	var current_dir = ProjectSettings.globalize_path(dir.get_current_dir())
	var network_backend_path = current_dir + "../BrowserNetwork/server.js"
	if(dir.file_exists(network_backend_path)):
		print("Found server.exe at " + network_backend_path)
		var arg = [network_backend_path]
		pid = OS.execute("node.exe", arg, false)
		print(pid)
		#dir.free()
	else:
		print("server.exe not found")
	zmq = Zeromq_wrapper.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("reload_page"):
		print(tab_tokens)
		#get_node("VBoxContainer/TabNode").print_tree()
		#getallnodes(get_node("VBoxContainer/TabNode"))
		
	var response = zmq.receive()
	if response.length()!=0:
		var parsedResponse = parse_json(response)
		var param = parsedResponse.data.param
		
		if parsedResponse.data.item=="text":
			tab_container.append_text(param.text)
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


func clear_url_bar():
	var urlBar = get_node("VBoxContainer/SearchPanelHBox/UrlHBoxContainer/LineEdit")
	urlBar.clear()
	pass;
	

func set_url(idx):
	var urlBar = get_node("VBoxContainer/SearchPanelHBox/UrlHBoxContainer/LineEdit")

func _on_LineEdit_text_entered(new_text):
	var activeTabId = tab_container.get_active_tab_id()
	var info = {
		"token": activeTabId,
		"url": new_text
	}
	
	var jsonString = JSON.print(info)
	print(jsonString)
	zmq.publish("network_backend",jsonString)
	#tab_info.append(info)
	
	pass # Replace with function body.
