extends Control
@onready var DialogBox = $CanvasLayer/DialogBox
@onready var background = $Background
@onready var AmbientSound = $"/root/AmbientSound"

var dataFilePath = "res://Static/data.json"

var dialogue
var currentStep
var imageIndex = 0;

func _ready() -> void:
	Events.connect("option_selected", on_option_selected);
	Events.connect("page_updated", on_page_updated);
	dialogue = load_json_file(dataFilePath);
	if(!currentStep):
		currentStep = dialogue["start"];
		update_background(currentStep["images"][imageIndex])
		DialogBox.add_dialog(currentStep["dialogue"], currentStep["options"], currentStep["audio"])

func on_page_updated(page: int):
	imageIndex = imageIndex + 1;
	print("ImageIndex ", imageIndex);
	print("PageIndex", page);
	if(currentStep["images"].size()-1 >= imageIndex):
		update_background(currentStep["images"][imageIndex]);

func on_option_selected(option: String) -> void:
	if(option == "menu"):
		reset()
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scenes/MainMenu.tscn")
	elif (option == "restart"):
		reset();
	else:
		imageIndex = 0
		currentStep = dialogue[option];
		update_background(currentStep["images"][imageIndex])
		DialogBox.add_dialog(currentStep["dialogue"], currentStep["options"], currentStep["audio"])

func load_json_file(filePath: String):
	if(FileAccess.file_exists(filePath)):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file");
	else:
		print("File doesn't exist ", filePath)

func update_background(imagePath: String):
	# TODO: update texture to size image appropriately
	background.texture = ResourceLoader.load(imagePath);

func reset():
	var ambientAudio: AudioStream = load("res://Assets/Audio/170084_normal-ambience.wav");
	AmbientSound.set_stream(ambientAudio);
	AmbientSound.play();
	imageIndex = 0
	currentStep = dialogue["start"];
	update_background(currentStep["images"][imageIndex])
	DialogBox.add_dialog(currentStep["dialogue"], currentStep["options"], currentStep["audio"])
