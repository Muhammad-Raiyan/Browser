extends TabContainer
var zmq = Zeromq_wrapper.new()
var tabTokenList = [1000] # By defauly, the first tab is always set to token 1000
var MAX_TOKEN = 10000
var MIN_TOKEN = 1

func _ready():
	print("Ready")
	pass

	
func createNewToken():
	var tempToken = randi()%MAX_TOKEN+MIN_TOKEN
	while(tabTokenList.has(tempToken)):
			tempToken = randi()%MAX_TOKEN+MIN_TOKEN;
	return tempToken
	

func _on_addTab_request(tabIdx):
	if get_tab_title(tabIdx) == "+":
		
		# Duplicate "+" tab / Create new "+" tab
		var activeTab = get_tab_control(tabIdx)
		var duplicateTab = activeTab.duplicate()
		print(tabIdx)
		
		# Set Tab Token
		var newToken = createNewToken()	
		activeTab.setTabToken(newToken)
		tabTokenList.append(newToken)
		
		# Add duplicate Tab to TabContainer  
		add_child(duplicateTab)
		
		# Swap titles of old "+" tab with newly created/duplicated tab 
		var duplicateTabIdx = duplicateTab.get_index()
		var title = "New Tab " + str(duplicateTabIdx)
		set_tab_title(tabIdx, title)
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
		print("Closing tab: " + str(active_tab.get_index()))
		var i = tabTokenList.find(active_tab.getTabToken())
		tabTokenList.remove(i)		# make the token available again 
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

	
	