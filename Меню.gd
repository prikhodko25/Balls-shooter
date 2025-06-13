extends Node2D

@onready var interactive_label: Label = $Label if has_node("Label") else null
@onready var second_label: Label = $Label2 if has_node("Label2") else null

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0.1, 0.1, 0.1))
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 0)
	style.border_color = Color(1, 1, 0)
	style.border_width_top = 4
	style.border_width_bottom = 4
	style.border_width_left = 4
	style.border_width_right = 4
	style.corner_radius_top_left = 10
	style.corner_radius_top_right = 10
	style.corner_radius_bottom_left = 10
	style.corner_radius_bottom_right = 10

	if interactive_label:
		interactive_label.text = "Почати гру" #  Відображення тексту, який є посиланням
		interactive_label.visible = true
		interactive_label.modulate.a = 1.0
		interactive_label.z_index = 1
		interactive_label.add_theme_font_size_override("font_size", 24)
		interactive_label.add_theme_color_override("font_color", Color(0, 0, 1))
		interactive_label.add_theme_stylebox_override("normal", style)
		print("Interactive label initialized with yellow frame")
	else:
		push_warning("InteractiveLabel not found!")

	if second_label:
		second_label.text = "Підказки" #  Відображення тексту, який є посиланням
		second_label.visible = true
		second_label.modulate.a = 1.0
		second_label.z_index = 1
		second_label.add_theme_font_size_override("font_size", 24)
		second_label.add_theme_color_override("font_color", Color(0, 0, 1))
		var second_frame_style = StyleBoxFlat.new()
		second_frame_style.bg_color = Color(1, 1, 0)
		second_frame_style.border_color = Color(1, 1, 0)
		second_frame_style.border_width_top = 4
		second_frame_style.border_width_bottom = 4
		second_frame_style.border_width_left = 4
		second_frame_style.border_width_right = 4
		second_frame_style.corner_radius_top_left = 10
		second_frame_style.corner_radius_top_right = 10
		second_frame_style.corner_radius_bottom_left = 10
		second_frame_style.corner_radius_bottom_right = 10
		second_label.add_theme_stylebox_override("normal", second_frame_style)
		print("Second label initialized with yellow frame")
	else:
		push_warning("SecondLabel not found!")

func _input(event: InputEvent) -> void:
	if interactive_label and interactive_label.visible and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		if interactive_label.get_global_rect().has_point(mouse_pos):
			get_tree().change_scene_to_file("res://Ігрове поле.tscn") #  Посилання на перехід до сцени ігрового поля
			print("Transitioning to Ігрове поле.tscn")
	
	if second_label and second_label.visible and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		if second_label.get_global_rect().has_point(mouse_pos):
			get_tree().change_scene_to_file("res://Підказки.tscn") #  Посилання на перехід до сцени підказок
			print("Transitioning to Підказки.tscn")
