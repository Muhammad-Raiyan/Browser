
extends TabContainer

var zmq
var pid
var createdTokenCount = 0

const SEARCH_ENVELOPE = "network_backend"
const DISPLAY_ENVELOPE = "render_backend"


#var rotation_ang = 50
#var angle_from = 75
#var angle_to = 195


func _ready():
	var dir = Directory.new()
	var current_dir = ProjectSettings.globalize_path(dir.get_current_dir())
	var network_backend_path = current_dir + "../BrowserNetwork/server.js"
	if(dir.file_exists(network_backend_path)):
		print("Found server.exe at " + network_backend_path)
		var arg = [network_backend_path]
		pid = OS.execute("node.exe", arg, false)
		print(pid)
	else:
		print("server.exe not found")
	zmq = Zeromq_wrapper.new()
	#_on_TabContainer_tab_changed(0)
	create_new_tab()
	


func _process(delta):
	if Input.is_action_just_pressed("close_tab"):
		_on_closeTabButton_pressed()

	if Input.is_action_just_pressed("new_tab"):
		create_new_tab()

	if Input.is_action_just_pressed("close_all_tab"):
		close_browser()
	
	# PLACE HOLDERS for future shortuts
	if Input.is_action_just_pressed("reload_page"):
#		var vec = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)
#		draw_circle(vec, get_viewport().size.x/4, Color.green)
		var activeTab = get_current_tab_control().get_child(0)
		var textLabel = RichTextLabel.new()
		textLabel.set_name("infoRichTextLabel")
		textLabel.add_text("You did not come,And marching Time drew on, and wore me numb,— Yet less for loss of your dear presence there Than that I thus found lacking in your make That high compassion which can overbear Reluctance for pure lovingkindness’ sake Grieved I, when, as the hope-hour stroked its sum, You did not come. You love not me, And love alone can lend you loyalty; –I know and knew it. But, unto the store Of human deeds divine in all but name, Was it not worth a little hour")
		textLabel.size_flags_vertical = SIZE_EXPAND_FILL
		textLabel.size_flags_horizontal = SIZE_EXPAND_FILL
		textLabel.scroll_active = false
		var textLabel2 = RichTextLabel.new()
		textLabel2.set_name("infoRichTextLabel3")
		textLabel2.add_text("info2")
		textLabel2.size_flags_vertical = SIZE_EXPAND_FILL
		textLabel2.size_flags_horizontal = SIZE_EXPAND_FILL
		textLabel2.scroll_active = false
		
		activeTab.add_child(textLabel)
		activeTab.add_child(textLabel2)
		update()
		print("Reload page ")

	if Input.is_action_just_pressed("show_history"):
		print("Show history page")
	
#	angle_from += rotation_ang
#	angle_to += rotation_ang
#
#	# We only wrap angles if both of them are bigger than 360
#	if angle_from > 360 and angle_to > 360:
#		angle_from = wrap(angle_from, 0, 360)
#		angle_to = wrap(angle_to, 0, 360)
#	update()
   

#func _draw():
#	var center = Vector2(200, 200)
#	var radius = 80
#	var color = Color(1.0, 0.0, 0.0)
#
#	draw_circle_arc( center, radius, angle_from, angle_to, color )


func draw_circle_arc(center, radius, angle_from, angle_to, color):
    var nb_points = 32
    var points_arc = PoolVector2Array()
    points_arc.push_back(center)
    var colors = PoolColorArray([color])

    for i in range(nb_points+1):
        var angle_point = deg2rad(angle_from + i * (angle_to - angle_from) / nb_points - 90)
        points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
    draw_polygon(points_arc, colors)

func wrap(value, min_val, max_val):
    var f1 = value - min_val
    var f2 = max_val - min_val
    return fmod(f1, f2) + min_val

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
	#OS.kill(pid)
	get_tree().quit()
	#get_tree().get_root().quit()


func _on_urlLineEdit_text_entered(url):
	
	var active_tab = get_current_tab_control()
	var jsonData = {
		"token": active_tab.getTabToken(),
		"arg": {
			"url": url
		}
	}
	active_tab.set_url(url)
	
	var jsonString = JSON.print(jsonData)
	var recieved = zmq.publish(SEARCH_ENVELOPE, jsonString)
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

