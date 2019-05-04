tool
extends Path2D

var size = Vector2()

onready var pb
onready var follow = $PathFollow2D

func _ready():
	pb = $"../ProgressBar"
	if Engine.editor_hint:
		pb.connect("resized",self,"onSliderResize")

func onSliderResize():
	createCurve()
	follow.position = Vector2(size.x,0)

func _physics_process(_delta):
	if !curve and Engine.editor_hint:
		createCurve()
		update()
		
func createCurve():
	print("creating curve")
	size = pb.rect_size * pb.rect_scale
	curve = Curve2D.new()
	curve.add_point(Vector2(0,size.y),Vector2(),Vector2(0,-size.y/2))
	curve.add_point(Vector2(size.x,0),Vector2(-size.x/2,0),Vector2())
	var val = curve.get_baked_length()
	pb.max_value = val
	pb.value = val
	pb.step = val / 100

func _draw():
	if !Engine.editor_hint:
		var p0 = null
		for p1 in curve.get_baked_points():
			if p0:
				draw_line(p0,p1,Color.red,3)
			p0 = p1