extends Node2D



func _on_sticky_note_pressed():
	#should cycle through messages for fun
	$TextureRect/StickyNote.text = "yeehaw"
	
func _on_quit_button_pressed():
	#add save game warning
	get_tree().quit()


func _on_submit_pressed():
	if(true):
		print("yay")
