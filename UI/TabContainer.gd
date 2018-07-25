extends TabContainer
var zmq = Zeromq_wrapper.new()
var createdTokenCount = 0


func _ready():
	print("Ready")
	_on_TabContainer_tab_changed(0)
	pass


func _process(delta):
	if Input.is_action_just_pressed("close_tab"):
		_on_closeTabButton_pressed()

	if Input.is_action_just_pressed("new_tab"):
		create_new_tab()

	if Input.is_action_just_pressed("close_all_tab"):
		close_browser()
	
	# PLACE HOLDERS for future shortuts
	if Input.is_action_just_pressed("reload_page"):
		print("Reload page")

	if Input.is_action_just_pressed("show_history"):
		print("Show history page")



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


func create_new_tab():
	var tabIdx = get_tab_count()-1
	# Duplicate "+" tab / Create new "+" tab
	var activeTab = get_tab_control(tabIdx)
	var duplicateTab = activeTab.duplicate()
		
	# Set Tab Token
	var newToken = createNewToken()	
	activeTab.setTabToken(newToken)
		
	# Add duplicate Tab to TabContainer  
	add_child(duplicateTab)
		
	# Swap titles of old "+" tab with newly created/duplicated tab 
	var duplicateTabIdx = duplicateTab.get_index()
	set_tab_title(tabIdx, "New Tab")
	set_tab_title(duplicateTabIdx, "+")
	print_tab_info("tab_created", tabIdx)



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
	get_tree().quit()


func _on_urlLineEdit_text_entered(url):
	
	var active_tab = get_current_tab_control()
	var jsonData = {
		"token": active_tab.getTabToken(),
		"url": url
	}
	active_tab.set_url(url)
	
	var jsonString = JSON.print(jsonData)
	var recieved = zmq.searchRequest(jsonString)
	active_tab.insert_text(recieved)


# Placeholder
func _on_TabContainer_tab_selected(tabIdx):
	print_tab_info("tab_selected", tabIdx)


func createNewToken():
	createdTokenCount = createdTokenCount + 1;
	return createdTokenCount;

func print_tab_info(msg, tabIdx):
	var activeTab = get_tab_control(tabIdx)
	print(msg + " Tab Index: " + str(tabIdx) + " Tab Token: " + str(activeTab.getTabToken()))

