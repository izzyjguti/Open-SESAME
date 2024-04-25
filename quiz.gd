extends Node2D

@onready var DisplayText = $TextureRect/QuizWindow/QuestionCore/Question
@onready var ListItem = $TextureRect/QuizWindow/QuestionCore/Answers
@onready var RestartButton = $TextureRect/QuizWindow/QuestionCore/RetryButton
@onready var FeedbackText = $TextureRect/ResponseWindow/ResponseCore/ResponseFeedback
@onready var FeedbackConfirm = $TextureRect/ResponseWindow/ResponseCore/Confirm

var ref = preload("res://reference.tscn")

var item : Dictionary


func _on_sticky_note_pressed():
	#should cycle through messages for fun
	$TextureRect/StickyNote.text = "Reminder: \nmeeting at 6\n-Marcus"
	
func _on_quit_button_pressed():
	#add save game warning
	get_tree().quit()

func _ready():
	var json_data = fillItems("res://JSON/quiz.json","res://JSON/phoneCall.json")
	if json_data and json_data is Array:
		QuizProg.questionList = json_data
		refresh_scene()
	else:
		print("Error reading JSON file")
	
func refresh_scene():
	if QuizProg.index_item >= 20:
		show_result()
	else:
		show_question()

func show_question():
	ListItem.show()
	RestartButton.hide()
	ListItem.clear()
	item = QuizProg.questionList[QuizProg.index_item]
	print(item["type"])
	if item["type"] == 1:
		DisplayText.text = item.question
		var options = item.answers
		for option in options:
			ListItem.add_item(option)
			
	else:
		print("go to phone")
		#function for phone anim
		$AnimatedSprite2D.show()
		$AnimatedSprite2D.play()
		await get_tree().create_timer(3).timeout
		get_tree().change_scene_to_file("res://phone.tscn")
		
	
func show_result():
	ListItem.hide()
	RestartButton.show()
	var score = round(QuizProg.correct / QuizProg.questionList.size() *100)
	var greet
	if score >= 60:
		greet = "Congratulation"
	else:
		greet = "Womp Womp"
	DisplayText.text = "{greet} ! Your Score is {score} %".format({"greet": greet,"score": score})

func read_json_file(filename):
	var filetext = FileAccess.get_file_as_string(filename)
	var json_data = JSON.parse_string(filetext)
	#print(json_data)
	return json_data

func _on_retry_pressed():
	QuizProg.correct = 0
	QuizProg.index_item = 0
	refresh_scene()

func _on_submit_pressed():
	var index = ListItem.get_selected_items();
	#print(index)
	#print(item.correctOptionIndex)
	if index.is_empty():
		return
	if index[0] == item.correctOptionIndex:
		QuizProg.correct += 1
		$TextureRect/ResponseWindow/ResponseHeader/ResponseName.text = "CORRECT!"
	else:
		$TextureRect/ResponseWindow/ResponseHeader/ResponseName.text = "INCORRECT"
	FeedbackText.text = item.correction
	$TextureRect/ResponseWindow.show()
	QuizProg.index_item += 1
	
func _on_confirm_pressed():
	$TextureRect/ResponseWindow.hide()
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

func _on_reference_button_pressed():
	QuizProg.jumpSource = 1
	var refInst = ref.instantiate()
	add_child(refInst)

	
func save_game(tempOrPerm):
	if(tempOrPerm):
		pass

func fillItems(filename1, filename2):
	var filedata1 = read_json_file(filename1)
	var filedata2 = read_json_file(filename2)
	var temp = randi_range(0,1)
	var keepGoing = true
	var questionBase : Array = []
	for i in range(0,20):
		#grab specific questions to put in new dict
		if i < 5:
			temp = 0
		keepGoing = true
		if temp == 0:
			#grab from file 1
			while keepGoing:
				temp = randi_range(0,filedata1.size()-1)
				if !questionBase.has(filedata1[temp]) or questionBase.is_empty(): 
					questionBase.append(filedata1[temp]);
					questionBase[i]["type"]=1
					keepGoing = false;
		else:
			#grab from file 2
			while keepGoing:
				temp = randi_range(0,filedata2.size()-1)
				if !questionBase.has(filedata2[temp]) or questionBase.is_empty():
					questionBase.append(filedata2[temp]);
					questionBase[i]["type"]=2
					keepGoing = false;
		temp = randi_range(0,1)
	print(questionBase)
	return questionBase
