extends Control
@onready var fd_load = $VBoxContainer/HBoxContainer/VBoxContainer/fd_load
@onready var scatter = $VBoxContainer/HBoxContainer/VBoxContainer3/ScatterPlot
@onready var line = $VBoxContainer/HBoxContainer/VBoxContainer3/LineGraph

var curr_file = 0

#maybe make it so it's just one route points thing to make it more scalable
#stores x, z, y
var route_points =  [[0,0,0]]

# Called when the node enters the scene tree for the first time.
func _ready():
	fd_load.current_dir = "/"
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

#TODO - Regex to verify file is correct type
func _on_fd_load_file_selected(path):
	if(curr_file == 0):
		read_json_coordinates(path, true)
		scatter.redraw_graph(route_points)
		line.redraw_graph(route_points)
	elif(curr_file == 1):
		read_json_coordinates(path, false)
	elif(curr_file == 2):
		pass
	else:
		pass


func lat_long_to_meters(lat, long, alt):
	var rad = 6371000+alt
	var radLat = lat * PI/180.0
	var radLong = long * PI/180.0
	var ans = []
	ans.append(rad * cos(radLat) * cos(radLong)) # Lat
	ans.append(rad * cos(radLat) * sin(radLong)) # Long
	ans.append(alt) # alt
	return ans

#The only fields we care about are Lat, Long, Alt(m), X, Y, Z.
func read_csv_coordinates(path, to):
	var coords = true
	var file = FileAccess.open(path, FileAccess.READ)
	var header = file.get_csv_line()
	if(header[0].to_upper() == "X" && header[1].to_upper() == "Y" && header[2].to_upper() == "Z"):
		coords = false
	var final = []
	var last_point = route_points[-1]
	while !file.eof_reached():
		var csv_row = file.get_csv_line()
		if(csv_row.size() < 3):
			break
		var x = float(csv_row[0])
		var y = float(csv_row[1])
		var z = float(csv_row[2])
		var row = [x, y, z]
		if(coords):
			row = lat_long_to_meters(x, y, z)
		final.append(row)
		
		var first_row = [final[0][0], final[0][1], final[0][2]]
		for i in final:
			i[0] = i[0] - first_row[0] + last_point[0]
			i[1] = i[1] - first_row[1] + last_point[1]
			i[2] = i[2] - first_row[2] + last_point[2]
	file.close()


func read_json_coordinates(path, to):
	var final = []
	var last_point = route_points[-1]
	var file = FileAccess.open(path, FileAccess.READ)
	var file_text = file.get_as_text()
	var json = JSON.new()
	var error = json.parse(file_text)
	if(error == OK):
		var json_data = json.data
		for i in json_data['features']:
			if(i['geometry']['type'] == 'LineString'):
				for j in i['geometry']['coordinates']:
					final.append(lat_long_to_meters(j[1], j[0], j[2]))
				break
		var first_row = [final[0][0], final[0][1], final[0][2]]
		for i in final:
			i[0]  = i[0] - first_row[0] + last_point[0]
			i[1]  = i[1] - first_row[1] + last_point[1]
			i[2]  = i[2] - first_row[2] + last_point[2]
	route_points = final

func _on_route_to_button_pressed():
	curr_file = 0
	fd_load.visible = true

func add_turn_around():
	pass

func _on_route_from_button_pressed():
	curr_file = 0
	fd_load.visible = true

func _on_back_button_pressed():
	menu_manager.load_menu(menu_manager.MENU_LEVEL.MAIN)
