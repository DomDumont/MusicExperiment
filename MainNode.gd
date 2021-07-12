extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var scale_penta = [0, 2, 4, 7, 9];
var full_scale_penta = [];
var old_position = Vector2(0,0)
var current_position_in_scale = Vector2(0,0)
var current_midi_note = Vector2(0,0)
var old_midi_note = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready():
	BuildPentaScale()
	#$AudioStreamPlayer/Multisampler.play_note("C")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):	
	HandleMouseMove()


func _on_Timer_timeout():
	var calculator: NoteValueCalculator = get_node("/root/NoteValue")
	
	if current_midi_note.x != old_midi_note.x :
		old_midi_note.x = current_midi_note.x
		var name = calculator.get_note_name(current_midi_note.x )
		var octave = calculator.get_note_octave(current_midi_note.x )
		$AudioStreamPlayer/Multisampler.play_note(name,octave)
	if current_midi_note.y != old_midi_note.y :	
		old_midi_note.y = current_midi_note.y
		var name = calculator.get_note_name(current_midi_note.y )
		var octave = calculator.get_note_octave(current_midi_note.y)
		$AudioStreamPlayer/Multisampler.play_note(name,octave)

func FilterCurrentNote(note,scale):
	var noteInOctave = note % 12;
	return scale.has(noteInOctave);
	
func BuildPentaScale():
	for i in range(36,120):
		if FilterCurrentNote(i,scale_penta):
			print(i)
			full_scale_penta.append(i)
	pass
	
func HandleMouseMove():
	var stepX = floor(get_viewport().get_visible_rect().size.x / full_scale_penta.size())
	var stepY = floor(get_viewport().get_visible_rect().size.y / full_scale_penta.size())
	var  oldCase = Vector2(floor(old_position.x / stepX),floor(old_position.y / stepY))
	var  newCase = Vector2(floor($Character.get_position().x / stepX),floor($Character.get_position().y / stepY))

	if newCase.y < oldCase.y and current_position_in_scale.y < full_scale_penta.size() - 1:
		current_position_in_scale.y += 1 
	if newCase.y > oldCase.y and current_position_in_scale.y > 0:
		current_position_in_scale.y -=1
	if newCase.x > oldCase.x and current_position_in_scale.x < full_scale_penta.size() - 1:
		current_position_in_scale.x +=1
	if newCase.x < oldCase.x and current_position_in_scale.x > 0:
		current_position_in_scale.x -=1


	current_midi_note.x = full_scale_penta[current_position_in_scale.x];
	current_midi_note.y = full_scale_penta[current_position_in_scale.y];
	
	old_position.x = $Character.get_position().x
	old_position.y = $Character.get_position().y
	
	$LabelWindowSize.text = "Window Size "
	$LabelWindowSize.text += str(get_viewport().get_visible_rect().size.x)
	$LabelWindowSize.text += " - "
	$LabelWindowSize.text += str(get_viewport().get_visible_rect().size.y)

	$LabelPosition.text = "Character Position "
	$LabelPosition.text += str(floor($Character.get_position().x))
	$LabelPosition.text += " - "
	$LabelPosition.text += str(floor($Character.get_position().y))

	$LabelMIDINote.text = "Current MIDI Notes "
	$LabelMIDINote.text += str(current_midi_note.x)
	$LabelMIDINote.text += " - "
	$LabelMIDINote.text += str(current_midi_note.y)
