extends Control

@export var point_size:int = 3
@export var line_size:int = 2
@export var color:Color = Color.AQUA
@export var background_color:Color = Color.WHITE_SMOKE
@export var border_color:Color = Color.DIM_GRAY



var drawn_values = [[0, 0]]

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
	var max_x = drawn_values[0][0]
	var max_y = drawn_values[0][1]
	var min_x = drawn_values[0][0]
	var min_y = drawn_values[0][1]
	for val in drawn_values:
		max_x = max(max_x, val[0])
		max_y = max(max_y, val[1])
		min_x = min(min_x, val[0])
		min_y = min(min_y, val[1])
		
	var last_x = remap(drawn_values[0][0], min_x, max_x, 0, scale.x)
	var last_y = remap(drawn_values[0][1], min_y, max_y, 0, scale.y)*-1+get_size().y
	for val in drawn_values:
		var x = remap(val[0], min_x, max_x, 0, scale.x)
		var y = remap(val[1], min_y, max_y, 0, scale.y)*-1+get_size().y
		draw_circle(Vector2(x,y), point_size, color)
		if(!(last_x == x && last_y == y)):
			draw_line(Vector2(last_x,last_y), Vector2(x,y), color, line_size)
		last_x = x
		last_y = y
