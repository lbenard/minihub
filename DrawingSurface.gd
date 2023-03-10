extends ColorRect

var pressed = false : set = _set_pressed
var is_drag = false # Special case for mobile drag events
var strokes = []
var previous_position = null
@export var brush_color = Color.BLACK
@export var brush_size = 1.0

func _on_gui_input(event):
	# TODO: `InputEventMouseButton` with #pressed = false is emitted when the mouse goes off the
	#   screen. Ideally, the stroke should continue to be drawn until a `InputEventMouseMotion` is
	#   emitted with #pressure = 0.0 
	if event is InputEventMouseButton:
		self.previous_position = event.position
		self.pressed = event.pressed
		self.is_drag = false
		return
	
	if event is InputEventScreenTouch:
		self.previous_position = event.position
		self.pressed = event.pressed
		self.is_drag = true
		return
	
	# Mouse behavior:
	# We only want to end the stroke when InputEventMouseButton 
	if event is InputEventScreenDrag:
		_add_line(self.previous_position, event.position, 1.0)
	elif event is InputEventMouseMotion:
		if event.pressure > 0.1:
			_add_line(self.previous_position, event.position, event.pressure)
		if self.is_drag == false:
			self.previous_position = event.position

func _add_line(start_position, end_position, pressure):
	_current_stroke().add_line(start_position, end_position, pressure, self.brush_color, self.brush_size)
	self.previous_position = end_position

func _set_pressed(value):
	if self.pressed == false && value == true:
		var new_stroke = Stroke.new()
		add_child(new_stroke)
		self.strokes.append(new_stroke)
	pressed = value

func _current_stroke():
	return self.strokes[self.strokes.size() - 1]

func _on_color_picker_color_changed(value):
	self.brush_color = value

func _on_h_slider_value_changed(value):
	self.brush_size = value

func _on_undo():
	var last_stroke = self.strokes.pop_back()
	last_stroke.queue_free()
	self.queue_redraw()

func _on_clear():
	for stroke in self.strokes:
		stroke.queue_free()
	self.strokes = []
	self.queue_redraw()
