extends TabContainer
# https://www.york.ac.uk/teaching/cws/wws/webpage1.html
var zmq
var pid
var createdTokenCount = 0
var demo_txt1 = "When you consider the radiance, that it does not withhold itself but pours its abundance without selection into every nook and cranny not overhung or hidden; when you consider"
#var icon = preload("icon.png")
var hist = []

var count_calls = 0;

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
	
	create_new_tab()
	


func _process(delta):
	if Input.is_action_just_pressed("close_tab"):
		_on_closeTabButton_pressed()

	if Input.is_action_just_pressed("new_tab"):
		create_new_tab()
		#set_current_tab(1)

	if Input.is_action_just_pressed("close_all_tab"):
		close_browser()
	
	# PLACE HOLDERS for future shortuts
	if Input.is_action_just_pressed("reload_page"):
		print("Reload page")
		print("Calls: " + str(count_calls))

	if Input.is_action_just_pressed("show_history"):
		print(hist)

	var response = zmq.receive()
	if response.length()!=0:
		var parsedResponse = parse_json(response)
		#print(parsedResponse.data)
		count_calls = count_calls + 1
		
		var active_tab = get_current_tab_control()
		var param = parsedResponse.data.param
		if parsedResponse.data.item=="text-box":
			var textLabel = RichTextLabel.new()
			textLabel.anchor_left=param.anchor_left
			textLabel.anchor_top=param.anchor_top
			textLabel.anchor_right=param.anchor_right
			textLabel.anchor_bottom=param.anchor_bottom
			textLabel.size_flags_horizontal = 1
			textLabel.size_flags_vertical = 1
			textLabel.margin_left=0
			textLabel.margin_top=0
			textLabel.margin_right=0
			textLabel.margin_bottom=0
			#print(param.text)
			textLabel.newline()
			textLabel.add_text(param.text)
			active_tab.add_child(textLabel, true)
		
		if parsedResponse.data.item=="image":
			var sprt = Sprite.new()
			sprt.set_texture(param.name)
			sprt.move_local_x(param.x)
			sprt.move_local_y(param.y)
			active_tab.add_child(sprt)
		
		if parsedResponse.data.item=="text":
			active_tab.append_text(param.text)

func _on_TabContainer_tab_changed(tabIdx):
	
	# New Tab Request
	if tabIdx == get_tab_count()-1:
		create_new_tab()
	else:
		print_tab_info("tab_changed", tabIdx)
		var searchbar = get_node("../topVBox/topHBox/urlHBox/urlLineEdit")
		var activeTab = get_tab_control(tabIdx)
		var url = activeTab.get_url()
		if searchbar != null && url == null:
			searchbar.clear()
		if searchbar == null && url != null:
			searchbar.append_at_cursor(url)
	get_current_tab_control().print_tree()


func create_new_tab():
	var tabIdx = get_tab_count()-1
	# Duplicate "+" tab / Create new "+" tab
	var activeTab = get_tab_control(tabIdx)
	
	var duplicateTab = activeTab.duplicate()
		
	# Set Tab Token
	var newToken = createNewToken()	
	activeTab.setTabToken(newToken)
		
	# Add duplicate Tab to TabContainer  
	add_child(duplicateTab, true)
		
	# Swap titles of old "+" tab with newly created/duplicated tab 
	var duplicateTabIdx = duplicateTab.get_index()
	set_tab_title(tabIdx, "New Tab")
	set_tab_title(duplicateTabIdx, "+")
	print_tab_info("tab_created", tabIdx)
	set_current_tab(tabIdx)


func _on_closeTabButton_pressed():
	var active_tab = get_current_tab_control()
	var previous_tab_idx = active_tab.get_index() - 1

	# Close the browser when there're only 2 tabs (as + is a tab)
	# Else close the current tab
	if active_tab.get_index() == 0 && get_tab_count() == 2:
		close_browser()
	
	else:
		print("Closing tab with Idx: " + str(active_tab.get_index()) + " Token: " + str(active_tab.getTabToken()))
		remove_child(active_tab)

		# Change focus from the closed tab to the previous tab otherwise on 
		# next _on_closeTabButton_pressed() signal, + tab will be closed
		if previous_tab_idx >= 0:
			current_tab = previous_tab_idx


func close_browser():
	print("Closing browser")
	#OS.kill(pid)
	get_node("/root").get_tree().quit()
	#get_tree().get_root().quit()


func _on_urlLineEdit_text_entered(url):
	
	var active_tab = get_current_tab_control()
	var jsonData = {
		"token": active_tab.getTabToken(),
		"url": url
	}
	active_tab.set_url(url)
	hist.append(url)
	var jsonString = JSON.print(jsonData)
	zmq.publish("network_backend",jsonString)
	#active_tab.insert_text(recieved)


# Placeholder
func _on_TabContainer_tab_selected(tabIdx):
	print_tab_info("tab_selected", tabIdx)


func createNewToken():
	createdTokenCount = createdTokenCount + 1;
	return createdTokenCount;

func print_tab_info(msg, tabIdx):
	var activeTab = get_tab_control(tabIdx)
	print(msg + " Tab Index: " + str(tabIdx) + " Tab Token: " + str(activeTab.getTabToken()) + " child count: " + str(activeTab.get_child_count()))
	
func getallnodes(node):
	for N in node.get_children():
        if N.get_child_count() > 0:
            print("["+N.get_name()+":"+ N.get_type()+"]")
            getallnodes(N)
        else:
            # Do something
            print("- "+N.get_name()+":"+ N.get_type())

