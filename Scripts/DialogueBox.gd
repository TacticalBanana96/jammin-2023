extends Polygon2D
@onready var Dialog = $Dialog
@onready var leftButton = $Left
@onready var rightButton = $Right
@onready var LeftLabel = $Left/LeftLabel
@onready var rightLabel = $Right/RightLabel
@onready var SoundEffect: AudioStreamPlayer2D = $SoundEffect
@onready var AmbientSound: AudioStreamPlayer2D = $"/root/AmbientSound"

var dialogArray = []
var buttonOptions = {}
var page = 0;
var paused = false
var leftValue;
var rightValue;
var soundEffects
func _ready() -> void:
	Dialog.text = ""
	reset_buttons()

func add_dialog(stepDialog: Array, options: Dictionary, audio: Dictionary):
	page = 0;
	reset_buttons()
	dialogArray.assign(stepDialog);
	Dialog.text = dialogArray[page]
	Dialog.set_visible_characters(0)
	buttonOptions = options;
	soundEffects = audio["effects"];
	if(audio["ambient"]):
		var ambientAudio: AudioStream = load(audio["ambient"]);
		AmbientSound.set_stream(ambientAudio);
		AmbientSound.play();
	if (soundEffects.size() > 0):
		if(soundEffects[0]):
			var currentEffect = soundEffects[0];
			if (currentEffect):
				print("PLAYING AUDIO", page);
				var audioStream: AudioStream = load(currentEffect);
				SoundEffect.set_stream(audioStream);
				SoundEffect.play();
	if (dialogArray.size() == 1):
		enableButtons();
		

func _input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		#print('Visible characters ',Dialog.get_visible_characters() , ' ',  Dialog.get_total_character_count())
		if Dialog.get_visible_characters() >= Dialog.get_total_character_count():
			#print('PAGE ',page , ' ',  dialogArray.size() -1)
			if page < dialogArray.size() -1:
				page += 1
				print('Number of sound effects',soundEffects.size() )
				if (soundEffects.size()-1 >= page):
					var currentEffect = soundEffects[page];
					if (currentEffect):
						print("PLAYING AUDIO", page);
						var audioStream: AudioStream = load(currentEffect);
						SoundEffect.set_stream(audioStream);
						SoundEffect.play();
				Events.emit_signal("page_updated", page);
				Dialog.text = dialogArray[page];
				Dialog.set_visible_characters(0)
			#else: 
				#Dialog.text = "";
		else:
			Dialog.set_visible_characters(Dialog.get_total_character_count());
			#print("ELSE", page, " ", dialogArray.size() -1 )
			if (page == dialogArray.size() -1):
				#print('ENABLE BUTTON')
				enableButtons();

func die():
	#paused = not paused
	#scene_tree.paused = paused
	#var container = get_parent()	
	#container.queue_free()		
	pass

func _process(delta):
	if Dialog.get_visible_characters() == Dialog.get_total_character_count():
		Dialog.set_visible_characters(Dialog.get_total_character_count());
		if (page == dialogArray.size() -1):
			#print('ENABLE BUTTON')
			enableButtons();

		
func _on_timer_timeout():
	Dialog.set_visible_characters(Dialog.get_visible_characters()+1)
	
func reset_buttons():
	LeftLabel.text = "";
	rightLabel.text = "";
	leftButton.disabled = true;
	rightButton.disabled = true;
	leftValue = null;
	rightValue = null;

func enableButtons():
	if(buttonOptions["left"]["value"] && buttonOptions["right"]["value"]):
		leftButton.disabled = false;
		LeftLabel.text = "[center]" + buttonOptions["left"]["text"] + "[/center]"
		leftValue = buttonOptions["left"]["value"]
		rightButton.disabled = false;
		rightLabel.text = "[center]" + buttonOptions["right"]["text"] + "[/center]"
		rightValue = buttonOptions["right"]["value"]
		return;
	else:
		leftButton.disabled = true;
		rightButton.disabled = true;
		return;

func _on_left_pressed():
	Events.emit_signal("option_selected", leftValue);


func _on_right_pressed():
	Events.emit_signal("option_selected", rightValue);
