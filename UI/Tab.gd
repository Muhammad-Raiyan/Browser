extends ScrollContainer

var tabToken = 1000;
var url = null;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	if get_child_count() == 0:
		#print("Line count: " + str(textLabel.get_line_count()))
		print("Tab Token: " + str(tabToken))
	pass

func _process(delta):
	pass;

func setTabToken(var num):
	tabToken = num
	

func getTabToken():
	return tabToken;
	
	
"""
	Append text to the info label 
"""
func append_text(text):
	var infoLabel = get_node("infoRichTextLabel")
	infoLabel.newline()
	infoLabel.add_text(text)
	


"""
	Clear the label and insert text to the info label 
"""
func insert_text(text):
	var infoLabel = get_child(0).get_node("infoRichTextLabel")
	infoLabel.clear()
	infoLabel.add_text(text)
	print(infoLabel.get_line_count())

func set_url(text):
	url = text


func get_url():
	return url
