extends Node2D

@onready var label: Label = $Label if has_node("Label") else null
@onready var return_label: Label = $Label2 if has_node("Label2") else null
@onready var front_sprite: Sprite2D = $FrontSprite if has_node("FrontSprite") else null

func _ready() -> void:
	if label:
		label.text = "Меню"  # Відображення тексту який повертає до меню
		label.visible = true
		label.modulate.a = 1.0
		label.z_index = 1
		label.add_theme_font_size_override("font_size", 32)
		label.add_theme_color_override("font_color", Color(0, 0, 0)) 
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER  
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER  
		# Роз
		label.position = Vector2(50, 50)  
		var background_style = StyleBoxFlat.new()
		background_style.bg_color = Color(1, 1, 0) 
		background_style.border_color = Color(0, 0, 0)  
		background_style.border_width_top = 2
		background_style.border_width_bottom = 2
		background_style.border_width_left = 2
		background_style.border_width_right = 2
		background_style.corner_radius_top_left = 8  
		background_style.corner_radius_top_right = 8  
		background_style.corner_radius_bottom_left = 8  
		background_style.corner_radius_bottom_right = 8  
		label.add_theme_stylebox_override("normal", background_style)
		label.add_theme_color_override("font_outline_color", Color(0, 0, 0)) 
		label.add_theme_constant_override("outline_size", 2)  
		print("Label initialized: text='Меню', visible=true")
	else:
		push_warning("Label not found in SecondScene!")
	
	if return_label:     #Відображення тексту підказок
		return_label.text = "🌑 Щоб задати напрямок руху кулі, проведіть мишею в потрібному напрямку.\n" + \
							"🌑 Якщо протягом трьох ходів ви не знищили жодної кулі, то додається нова лінія куль.\n" + \
							"🌑 Якщо кулі заповнюють весь екран, то ви програли."
		return_label.visible = true
		return_label.modulate.a = 1.0
		return_label.z_index = 0 
		return_label.add_theme_font_size_override("font_size", 24)
		return_label.add_theme_color_override("font_color", Color(1, 1, 1))  
		return_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT  
		return_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		
		var background_style = StyleBoxFlat.new()
		# Напівпрозорий чорний фон
		background_style.bg_color = Color(0, 0, 0, 0.5)  
		# Жовта рамка
		background_style.border_color = Color(1, 1, 0)  
		background_style.border_width_top = 2
		background_style.border_width_bottom = 2
		background_style.border_width_left = 2
		background_style.border_width_right = 2
		background_style.corner_radius_top_left = 8  
		background_style.corner_radius_top_right = 8  
		background_style.corner_radius_bottom_left = 8  
		background_style.corner_radius_bottom_right = 8  
		return_label.add_theme_stylebox_override("normal", background_style)
		return_label.add_theme_color_override("font_outline_color", Color(0, 0, 0)) 
		return_label.add_theme_constant_override("outline_size", 2) 
		print("ReturnLabel initialized: text='Підказки', visible=true")
	else:
		push_warning("ReturnLabel not found in SecondScene!")
	
	if front_sprite:
		front_sprite.visible = true
		front_sprite.modulate.a = 1.0
		front_sprite.z_index = 2  
		print("FrontSprite initialized: visible=true")
	else:
		push_warning("FrontSprite not found in SecondScene!")
	

	RenderingServer.set_default_clear_color(Color(0, 0, 0))

func _input(event: InputEvent) -> void:
	if label and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		if label.get_global_rect().has_point(mouse_pos):
			get_tree().change_scene_to_file("res://Меню.tscn")  # Повернення до першої сцени
			print("Switching back to Меню.tscn via Label")
