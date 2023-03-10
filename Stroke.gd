extends Control
class_name Stroke

class Line:
	var start_position
	var end_position
	var pressure
	var color
	var size

@export var lines = []

func add_line(start_position, end_position, pressure, color, brush_size):
	var stroke = Line.new()
	stroke.start_position = start_position
	stroke.end_position = end_position
	stroke.pressure = pressure
	stroke.color = color
	stroke.size = brush_size
	self.lines.append(stroke)
	self.queue_redraw()

func _draw():
	for line in self.lines:
		self.draw_circle(line.start_position, line.size / 2.0, line.color)
		self.draw_line(line.start_position, line.end_position, line.color, line.size * line.pressure, false)
		self.draw_circle(line.end_position, line.size / 2.0, line.color)
