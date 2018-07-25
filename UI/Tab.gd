extends Tabs

var tabToken = 1000;
var url = null;

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
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
	var infoLabel = get_node("infoRichTextLabel")
	infoLabel.clear()
	infoLabel.add_text(text)


func set_url(text):
	url = text


func get_url():
	return url
