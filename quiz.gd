extends Node2D

@onready var DisplayText = $TextureRect/QuizWindow/QuestionCore/Question
@onready var ListItem = $TextureRect/QuizWindow/QuestionCore/Answers
@onready var RestartButton = $TextureRect/QuizWindow/QuestionCore/RestartButton

var items : Array = []
var item : Dictionary
var index_item : int = 0

var correct : float = 0

func _on_sticky_note_pressed():
	#should cycle through messages for fun
	$TextureRect/StickyNote.text = "yeehaw"
	
func _on_quit_button_pressed():
	#add save game warning
	get_tree().quit()

func _ready():
	var json_data = read_json_file("gfx/Questions.json")
	if json_data and json_data is Array:
		items = json_data
		refresh_scene()
	else:
		print("Error reading JSON file")
	

func refresh_scene():
	if index_item >= items.size():
		show_result()
	else:
		show_question()

func show_question():
	ListItem.show()
	RestartButton.hide()
	ListItem.clear()
	item = items[index_item]
	DisplayText.text = item.question
	var options = item.options
	for option in options:
		ListItem.add_item(option)

func show_result():
	ListItem.hide()
	RestartButton.show()
	var score = round(correct / items.size() *100)
	var greet
	if score >= 60:
		greet = "Congratulation"
	else:
		greet = "Womp Womp"
	DisplayText.text = "{greet} ! Your Score is {score}".format({"greet": greet,"score": score})


func read_json_file(filename):
	var text = FileAccess.get_file_as_string(filename)
	var json = JSON.new()
	var json_data = json.parse(text)
	print(json_data)
	return json_data

func _on_item_list_item_selected(index):
	if index == item.correctOptionIndex:
		correct += 1
	index_item += 1
	refresh_scene()


func _on_button_pressed():
	correct = 0
	index_item = 0
	refresh_scene()





func _on_submit_pressed():
	if(true):
		print("yay")
