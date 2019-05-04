extends Node2D

var pressed = ""
var pointer = Vector2()

var isInsideKnob = false
var isInsideSlider = false
const KNOB_SPEED_MULTIPLIER = 5.0
onready var pb = $ProgressBar
onready var path = $Path2D
onready var curve = path.curve
onready var follow = path.get_node("PathFollow2D")
onready var knob = follow.get_node("TextureRect")

func _ready():
	knob.connect("mouse_entered",self,"isInside",["isInsideKnob",true])
	knob.connect("mouse_exited",self,"isInside",["isInsideKnob",false])
	pb.connect("mouse_entered",self,"isInside",["isInsideSlider",true])
	pb.connect("mouse_exited",self,"isInside",["isInsideSlider",false])

func isInside(type,val):
	set(type,val)

func _input(event):
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		if event is InputEventMouseButton:
			if !event.pressed:
				pressed = ""
				follow.modulate = Color("80ffffff")
				update()
			elif isInsideKnob:
				pressed = "knob"
				follow.modulate = Color.green
				pointer = follow.position
			elif isInsideSlider:
				pressed = "slider"
		if pressed:
			if pressed == "slider":
				pointer = event.position - position
			elif event is InputEventMouseMotion:
				pointer = follow.position + event.relative * KNOB_SPEED_MULTIPLIER
			update()

func _draw():
	if pressed:
		var closest_point = curve.get_closest_point(pointer)
		draw_line(closest_point,pointer,Color.blue,2)
		draw_circle(closest_point,5,Color.white)
		
		var closest_offset = curve.get_closest_offset(pointer)
		follow.offset = closest_offset
		pb.value = closest_offset
