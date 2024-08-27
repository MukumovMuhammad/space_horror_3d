extends OmniLight3D



func _on_e_component_set_electricity(is_on):
	print_debug("Recieved ", is_on)
	if is_on:
		self.show()
	else:
		self.hide()
