extends Control

@export var point_size:int = 3
@export var line_size:int = 2
@export var color:Color = Color.AQUA
@export var background_color:Color = Color.WHITE_SMOKE
@export var border_color:Color = Color.DIM_GRAY


var drawn_values = [[0,0,0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func redraw_graph(values):
	drawn_values = values
	queue_redraw()

func _draw():
	var scale = get_size()
	draw_rect(Rect2(Vector2(0,0), Vector2(scale.x, scale.y)), background_color)
	draw_rect(Rect2(Vector2(0,0), Vector2(scale.x, scale.y)), border_color, false, 2)
	var max_z = drawn_values[0][2]
	var min_z = drawn_values[0][2]
	var min_dist = 0
	var max_dist = 0
	var last_val = [0,0,0]
	for val in drawn_values:
		max_z = max(max_z, val[2])
		min_z = min(min_z, val[2])
		max_dist += sqrt(pow(val[0] - last_val[0], 2) + pow(val[1] - last_val[1], 2))
		last_val = val
	var last_z = remap(drawn_values[0][2], min_z, max_z, 0, scale.y)*-1+get_size().y
	var last_dist = 0
	var dist = 0
	last_val = [0,0,0]
	for val in drawn_values:
		var z = remap(val[2], min_z, max_z, 0, scale.y)*-1+get_size().y
		dist += sqrt(pow(val[0] - last_val[0], 2) + pow(val[1] - last_val[1], 2))
		var temp = remap(dist, min_dist, max_dist, 0, scale.x)
		var temp2 = remap(last_dist, min_dist, max_dist, 0, scale.x)
		draw_circle(Vector2(temp,z), point_size, color)
		if(!(last_z == z && temp2 == temp)):
			draw_line(Vector2(temp2,last_z), Vector2(temp,z), color, line_size)
		last_z = z
		last_dist = dist
		last_val = val
