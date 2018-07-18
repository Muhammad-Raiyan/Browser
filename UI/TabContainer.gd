extends TabContainer
var zmq = Zeromq_wrapper.new()
var createdTokenCount = 0

func _ready():
	print("Ready")
	#_on_addTab_request(0)
	#_on_TabContainer_tab_changed(0)
	pass

func createNewToken():
	createdTokenCount = createdTokenCount + 1;
	return createdTokenCount;
	

func _on_TabContainer_tab_changed(tabIdx):
	
	print_tab_info("tab_changed", tabIdx)
	
	# New Tab Request
	if tabIdx == get_tab_count()-1:
		# Duplicate "+" tab / Create new "+" tab
		var activeTab = get_tab_control(tabIdx)
		var duplicateTab = activeTab.duplicate()
		print("TabIdx: " + str(tabIdx))
		
		# Set Tab Token
		var newToken = createNewToken()	
		activeTab.setTabToken(newToken)
		
		# Add duplicate Tab to TabContainer  
		add_child(duplicateTab)
		
		# Swap titles of old "+" tab with newly created/duplicated tab 
		var duplicateTabIdx = duplicateTab.get_index()
		set_tab_title(tabIdx, "New Tab")
		set_tab_title(duplicateTabIdx, "+")
	

func _on_closeTabButton_pressed():
	var active_tab = get_current_tab_control()
	var previous_tab_idx = active_tab.get_index() - 1

	# Close the browser when there're only 2 tabs (as + is a tab)
	# Else close the current tab
	if active_tab.get_index() == 0 && get_tab_count() == 2:
		print("Closing browser")
		get_tree().quit()
	
	else:
		# Close requested tab
		print("Closing tab with Idx: " + str(active_tab.get_index()) + " Token: " + str(active_tab.getTabToken()))
		remove_child(active_tab)

		# Change focus from the closed tab to the previouds tab otherwise on 
		# next _on_closeTabButton_pressed() signal, + tab will be closed
		if previous_tab_idx >= 0:
			current_tab = previous_tab_idx
		

func _on_urlLineEdit_text_entered(new_text):
	# Print the entered url on tab
	var active_tab = get_current_tab_control()
	
	var jsonData = {
		"token": active_tab.getTabToken(),
		"url": new_text
	}
	var jsonString = JSON.print(jsonData)
	active_tab.url_handler(jsonString)
	var recieved = zmq.searchRequest(jsonString)
	active_tab.append_text(recieved)


func _on_TabContainer_tab_selected(tabIdx):
	print("Tab Selected 1: " + str(tabIdx))
	pass # Replace with function body.
	

func print_tab_info(msg, tabIdx):
	var activeTab = get_tab_control(tabIdx)
	print(msg + "Tab Index: " + str(tabIdx) + " Tab Token: " + str(activeTab.getTabToken()))
	
	
