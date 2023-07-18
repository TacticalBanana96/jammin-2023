extends RichTextLabel

@onready var scene_tree: = get_tree()

var dialog = []
var page = 0
var paused = false

func _ready() -> void:
	pass;
	#pause game
	#paused = not paused
	#scene_tree.paused = paused
#	if(dialog.size() > 0):
#		add_text(dialog[page])
#		set_visible_characters(0)
	#set_process_input(true)
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		print('VISIBLE', get_visible_characters())
		print('TOTAL',get_total_character_count() )
		if get_visible_characters() >= get_total_character_count():
			print("PAGE ", page)
			print("Dialog size ", dialog.size())
			if page < dialog.size() -1:
				page += 1
				text = dialog[page];
				print("HERE")
				print(dialog[page])
				set_visible_characters(0)
			else: 
				text = ""
		else:
			set_visible_characters(get_total_character_count())

func die():
	paused = not paused
	scene_tree.paused = paused
	var container = get_parent()	
	container.queue_free()		


func _on_timer_timeout():
	set_visible_characters(get_visible_characters()+1)
	
func add_dialog(stepDialog: Array)->void:
	dialog = stepDialog;
	text = dialog[page];
	print(text)
	print(dialog[page]);
	print(dialog.size())
	set_visible_characters(0);
