extends Node2D

@onready var DisplayText = $TextureRect/QuizWindow/QuestionCore/QuestionText
@onready var ListItem = $TextureRect/QuizWindow/QuestionCore/Answers
@onready var FeedbackText = $TextureRect/ResponseWindow/ResponseCore/ResponseFeedback


var ref = preload("res://reference.tscn")

var item : Dictionary


func _on_sticky_note_pressed():
	#should cycle through messages for fun
	$TextureRect/StickyNote.text = "Reminder: \nmeeting at 6\n-Marcus"
	

func _ready():
	refresh_scene()
	
func refresh_scene():
	if QuizProg.index_item >= QuizProg.questionList.size():
		#switch back to quiz, then show result
		pass
	else:
		show_question()

func show_question():
	$TextureRect/ResponseWindow.hide()
	ListItem.show()
	ListItem.clear()
	item = QuizProg.questionList[QuizProg.index_item]
	print(item["type"])
	if item["type"] == 2:
		DisplayText.text = item.name+": "+item.message
		#DisplayText.text = item.name +": "+item.message
		var options = item.replies
		for option in options:
			ListItem.add_item(option)
			
	else:
		get_tree().change_scene_to_file("res://quiz.tscn")
	

func _on_submit_pressed():
	var index = ListItem.get_selected_items();
	#print(index)
	#print(item.correctOptionIndex)
	if index.is_empty():
		return
	if index[0] == item["correctOptionIndex"]:
		QuizProg.correct += 1
		$TextureRect/ResponseWindow/ResponseHeader/ResponseName.text = "Good choice!"
	else:
		$TextureRect/ResponseWindow/ResponseHeader/ResponseName.text = "Uhm....."
	FeedbackText.text = item.consequences[index[0]]
	$TextureRect/ResponseWindow.show()
	QuizProg.index_item += 1




func _on_reference_button_pressed():
	QuizProg.jumpSource = 2;
	var refInst = ref.instantiate()
	add_child(refInst)



func _on_confirm_pressed():
	refresh_scene()
