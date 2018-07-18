extends Tabs

var tabToken = 1000;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


func setTabToken(var num):
	tabToken = num
	print("Tab Token: " + str(tabToken))
	

func getTabToken():
	return tabToken;
	

"""
	Handles url request
"""
func url_handler(url):
	var infoLabel = get_node("infoRichTextLabel")
	infoLabel.newline()
	infoLabel.add_text(url)
	pass

	
"""
	Append text to the info label 
"""
func append_text(text):
	var infoLabel = get_node("infoRichTextLabel")
	infoLabel.newline()
	infoLabel.add_text(text)
	pass
	
	