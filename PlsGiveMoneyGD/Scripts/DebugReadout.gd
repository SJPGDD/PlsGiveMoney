extends Label

#The current lines to be displayed
var lines = []

#Tracks if any changes were made this frame,
#to save some processing power on static frames
var should_refresh = false

#If the contents of lines changed this frame,
#reconcatonate all the lines and set the label
#text to the new combination
func _process(delta):
	if should_refresh:
		text = ""
		for line in lines:
			text += line + "\n"
		should_refresh = false

#Sets a given line index (0..) to display
#the value for the given tag.
func set_line(line, tag, value):
	if lines.size() <= line:
		lines.resize(line + 1)
	lines[line] = "%s: %s" % [tag, value]
	should_refresh = true