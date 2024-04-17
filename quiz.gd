extends Node2D

@onready var DisplayText = $TextureRect/QuizWindow/QuestionCore/Question
@onready var ListItem = $TextureRect/QuizWindow/QuestionCore/Answers
@onready var RestartButton = $TextureRect/QuizWindow/QuestionCore/RetryButton

var items : Array = []
var item : Dictionary
var index_item : int = 0
var correct : float = 0

func _on_sticky_note_pressed():
	#should cycle through messages for fun
	$TextureRect/StickyNote.text = "Reminder: \nmeeting at 6\n-Marcus"
	
func _on_quit_button_pressed():
	#add save game warning
	get_tree().quit()

func _ready():
	var json_data = read_json_file("Questions.json")
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
	var options = item.answers
	for option in options:
		ListItem.add_item(option,load("res://Button Textures/radio.png"))
	

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
	var filetext = FileAccess.get_file_as_string(filename)
	var json_data = JSON.parse_string(filetext)
	#print(json_data)
	return json_data

func _on_retry_pressed():
	correct = 0
	index_item = 0
	refresh_scene()

func _on_submit_pressed():
	var index = ListItem.get_selected_items();
	#print(index)
	#print(item.correctOptionIndex)
	if index.is_empty():
		return
	if index[0] == item.correctOptionIndex:
		correct += 1
	index_item += 1
	refresh_scene()


func _on_answers_item_selected(index):
	print(index)
	for i in range(1,5):
		#print(i)
		if i == index:
			ListItem.set_item_icon(index,load("res://Button Textures/radio selected.png"))
		else:
			ListItem.set_item_icon(index,load("res://Button Textures/radio.png"))
	
	pass # Replace with function body.
