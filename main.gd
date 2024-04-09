extends Node2D

func _on_quit_pressed():
	get_tree().quit()

func _on_start_pressed():
	var delay = Timer.new();
	delay.wait_time = 2;
	delay.autostart =true;
	get_tree().change_scene_to_file("res://quiz.tscn")

func _on_load_pressed():
	pass
