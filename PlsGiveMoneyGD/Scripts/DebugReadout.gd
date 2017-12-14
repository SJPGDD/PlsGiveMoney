extends Label

var lines = []
var should_refresh = false

func _process(delta):
	if should_refresh:
		text = ""
		for line in lines:
			text += line + "\n"
		should_refresh = false

func set_line(line, tag, value):
	if lines.size() <= line: lines.resize(line + 1)
	lines[line] = "%s: %s" % [tag, value]
	should_refresh = true