extends Control

@export var websocket_url = "ws://localhost:8080/ws"
var client = WebSocketPeer.new()

@onready var message_panel = $VBoxContainer/Panel/MarginContainer/ScrollContainer/VBoxContainer

func _ready():
	client.connect_to_url(websocket_url)

func _process(_delta):
	client.poll()
	var state = client.get_ready_state()
	if state == WebSocketPeer.STATE_OPEN:
		while client.get_available_packet_count():
			var message_label = Label.new()
			message_label.text = client.get_packet().get_string_from_utf8()
			message_panel.add_child(message_label)
