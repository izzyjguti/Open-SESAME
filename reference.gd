extends Node2D

var PageLNum = 0;
var items : Array = []
var item : Dictionary
@onready var headL = $TextureRect2/BookBack/PageLeft/HeadingL
@onready var bodyL = $TextureRect2/BookBack/PageLeft/BodyL
@onready var headR = $TextureRect2/BookBack/PageRight/HeadingR
@onready var bodyR = $TextureRect2/BookBack/PageRight/BodyR

func _on_return_pressed():
	if QuizProg.jumpSource == 1:
		print("to quiz")
		get_tree().change_scene_to_file("res://quiz.tscn")
	else:
		print("to phone")
		get_tree().change_scene_to_file("res://phone.tscn")

func _ready():
	var json_data = read_json_file("res://JSON/referenceBook.json")
	if json_data and json_data is Array:
		items = json_data
		pageTurn(-2,true)
	else:
		print("Error reading JSON file")
	
#read question file
func read_json_file(filename):
	var filetext = FileAccess.get_file_as_string(filename)
	var json_data = JSON.parse_string(filetext)
	#print(json_data)
	return json_data
	

func pageTurn(currentPageLNum, LorR):
	#l is false, right is true
	var pageNew
	var tempText = ""
	if(LorR):
		pageNew = currentPageLNum+2
	else:
		pageNew = currentPageLNum-2
	#for page L
	headL.text = items[pageNew].title
	for i in items[pageNew].definitions:
		tempText+="\n-"+i
	bodyL.text = tempText
	if (pageNew+1 < items.size()):
		#for page R
		headR.text = items[pageNew+1].title
		tempText = ""
		for i in items[pageNew+1].definitions:
			tempText+="\n-"+i
		bodyR.text = tempText
	else:
			headR.text = ""
			bodyR.text = ""


func _on_flip_back_pressed():
	if PageLNum > 0:
		pageTurn(PageLNum,false)
		PageLNum -=2
		



func _on_flip_forward_pressed():
	if PageLNum+1 < items.size():
		pageTurn(PageLNum,true)
		PageLNum +=2
	pass # Replace with function body.
