extends Node2D

@onready var bubble_counter_label: Label = $Label if has_node("Label") else null
@onready var celebration_sprite: Sprite2D = $Sprite2D4 if has_node("Sprite2D4") else null
@onready var instruction_label: Label = $InstructionLabel if has_node("InstructionLabel") else null
@onready var sprite: Sprite2D = $Sprite2D2 if has_node("Sprite2D2") else null
@onready var second_button: Button = $Button2 if has_node("Button2") else null
@onready var final_label: Label = $Label3 if has_node("Label3") else null
@onready var third_button: Button = $Button3 if has_node("Button3") else null
@onready var extra_sprite: Sprite2D = $Sprite2D5 if has_node("ExtraSprite") else null
@onready var level_label: Label = $LevelLabel if has_node("LevelLabel") else null
@onready var counter_sprite: Sprite2D = $CounterSprite if has_node("CounterSprite") else null
@onready var link_label: Label = $LinkLabel if has_node("LinkLabel") else null
@onready var new_sprite: Sprite2D = $ExtraSprite2 if has_node("ExtraSprite2") else null
@onready var restart_button: Button = $RestartButton if has_node("RestartButton") else null
@onready var exit_label: Label = $ExitLabel if has_node("ExitLabel") else null

var current_bubble: MovingBubble = null
var bubble_colors: Array[Color] = [Color(1, 0, 0), Color(1, 1, 0), Color(0, 0, 1)]
var bubble_destroyed_count: int = 0
var has_blue_bubble: bool = false
var is_first_game: bool = true
var moves_without_grid_destruction: int = 0
var grid_row_count: int = 4
var current_level: int = 0

func _ready() -> void:
	RenderingServer.set_default_clear_color(Color(0, 0, 0))
	var style = StyleBoxFlat.new()
	style.bg_color = Color(1, 1, 0)
	style.border_color = Color(0, 0, 0)
	style.border_width_top = 2
	style.border_width_bottom = 2
	style.border_width_left = 2
	style.border_width_right = 2
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8

	if bubble_counter_label:
		bubble_counter_label.text = "0"
		bubble_counter_label.visible = true
		bubble_counter_label.modulate.a = 1.0
		bubble_counter_label.z_index = 4
		bubble_counter_label.add_theme_font_size_override("font_size", 24)
		bubble_counter_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		bubble_counter_label.add_theme_constant_override("outline_size", 2)
		print("Counter label initialized: text=0, visible=true, modulate.a=1.0, z_index=4, font_size=24, outline_size=2")
	else:
		push_warning("Label not found!")

	if level_label:
		level_label.text = "Рівень: 1"
		level_label.visible = true
		level_label.modulate.a = 1.0
		level_label.z_index = 4
		level_label.add_theme_font_size_override("font_size", 24)
		level_label.add_theme_color_override("font_color", Color(1, 1, 1))
		level_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		level_label.add_theme_constant_override("outline_size", 2)
		print("Level label initialized: text='Level: 1', visible=true, z_index=4")
	else:
		push_warning("LevelLabel not found!")

	if celebration_sprite:
		celebration_sprite.visible = false
		celebration_sprite.z_index = 1
		print("Celebration sprite initialized: visible=false")
	else:
		push_warning("Sprite2D4 not found!")

	if sprite:
		sprite.visible = false
		sprite.z_index = 2
		sprite.modulate.a = 1.0
		print("Sprite2D2 initialized: visible=false, modulate.a=1.0, z_index=2")
	else:
		push_warning("Sprite2D2 not found!")

	if instruction_label:
		instruction_label.visible = true
		print("Instruction label initialized: visible=true")
	else:
		push_warning("InstructionLabel not found!")

	if second_button:
		second_button.visible = false
		second_button.add_theme_stylebox_override("normal", style)
		second_button.add_theme_color_override("font_color", Color(0, 0, 0))
		second_button.z_index = 2
		second_button.connect("pressed", Callable(self, "_on_second_button_pressed"))
		print("Second button initialized: visible=false")
	else:
		push_warning("Button2 not found!")

	if final_label:
		final_label.visible = false
		final_label.modulate.a = 0
		final_label.z_index = 4
		final_label.text = ""
		final_label.add_theme_font_size_override("font_size", 40)
		final_label.add_theme_color_override("font_color", Color(1, 1, 1))
		final_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		final_label.add_theme_constant_override("outline_size", 2)
		final_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		final_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		print("Label3 initialized: text='', font_size=40, z_index=4, visible=true")
	else:
		print("Label3 not found!")

	if third_button:
		third_button.visible = true
		third_button.text = "ЗМІНИТИ"
		third_button.add_theme_stylebox_override("normal", style)
		third_button.add_theme_color_override("font_color", Color(0, 0, 0))
		third_button.z_index = 2
		third_button.connect("pressed", Callable(self, "_on_third_button_pressed"))
		print("Third button initialized: visible=true, text='Change Color'")
	else:
		push_warning("Button3 not found!")

	if extra_sprite:
		extra_sprite.visible = false
		extra_sprite.z_index = 1
		extra_sprite.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
		print("Extra sprite initialized: visible=false, z_index=1, position=center")
	else:
		push_warning("ExtraSprite not found!")

	if counter_sprite:
		counter_sprite.visible = true
		counter_sprite.z_index = -1
		counter_sprite.modulate = Color(1, 1, 0)
		print("Counter sprite initialized: visible=true, z_index=-1")
	else:
		push_warning("CounterSprite not found!")

	if link_label:
		link_label.text = "Завершити"  # Змінено текст на "Завершити"
		var red_background = StyleBoxFlat.new()
		red_background.bg_color = Color(1, 0, 0)  # Червоний фон
		link_label.add_theme_stylebox_override("normal", red_background)
		link_label.add_theme_color_override("font_color", Color(0, 0, 0))  # Чорний текст
		link_label.z_index = 2
		link_label.visible = false  # Початково прихований, як і second_button
		print("Link label initialized: text='Завершити', visible=false")
	else:
		push_warning("LinkLabel not found!")

	if new_sprite:
		new_sprite.visible = false
		new_sprite.z_index = 1
		new_sprite.position = Vector2(get_viewport_rect().size.x / 2, get_viewport_rect().size.y / 2)
		print("New sprite initialized: visible=false, z_index=1, position=center")
	else:
		push_warning("ExtraSprite2 not found!")

	if restart_button:
		restart_button.visible = false
		restart_button.add_theme_stylebox_override("normal", style)
		restart_button.add_theme_color_override("font_color", Color(0, 0, 0))
		restart_button.z_index = 2
		restart_button.text = "Спробувати ще раз"
		restart_button.connect("pressed", Callable(self, "_on_restart_button_pressed"))
		print("Restart button initialized: visible=false, text='Спробувати ще раз'")
	else:
		push_warning("RestartButton not found!")

	if exit_label:
		exit_label.text = "Меню"
		var yellow_background = StyleBoxFlat.new()
		yellow_background.bg_color = Color(1, 1, 0)  # Жовтий фон
		yellow_background.border_color = Color(0, 0, 0)  # Чорна рамка
		yellow_background.border_width_top = 2
		yellow_background.border_width_bottom = 2
		yellow_background.border_width_left = 2
		yellow_background.border_width_right = 2
		yellow_background.corner_radius_top_left = 8
		yellow_background.corner_radius_top_right = 8
		yellow_background.corner_radius_bottom_left = 8
		yellow_background.corner_radius_bottom_right = 8
		exit_label.add_theme_stylebox_override("normal", yellow_background)
		exit_label.add_theme_color_override("font_color", Color(0, 0, 0))  # Чорний текст
		exit_label.z_index = 2
		exit_label.visible = true
		exit_label.mouse_filter = Control.MOUSE_FILTER_STOP  # Додано для інтерактивності
		exit_label.connect("gui_input", Callable(self, "_on_exit_label_input"))
		print("Exit label initialized: text='Меню', visible=true, rect=", exit_label.get_global_rect())
	else:
		push_warning("ExitLabel not found!")

	var shader_material = ShaderMaterial.new()
	var shader = Shader.new()
	shader.code = """
shader_type canvas_item;

uniform float corner_radius : hint_range(0.0, 1.0) = 0.2;

void fragment() {
	vec2 uv = UV;
	vec2 size = vec2(1.0);
	float radius = corner_radius;

	vec2 q = abs(uv - 0.5);
	vec2 corner = vec2(0.5 - radius);
	float dist = length(max(q - corner, 0.0)) - radius;

	float alpha = 1.0 - smoothstep(0.0, 0.05, dist);

	COLOR = texture(TEXTURE, uv);
	COLOR.a *= alpha;
}
"""
	shader_material.shader = shader
	shader_material.set_shader_parameter("corner_radius", 0.2)
	if celebration_sprite:
		celebration_sprite.material = shader_material
		print("Shader applied to celebration sprite")
	else:
		push_warning("Cannot apply shader material: celebration_sprite not found!")
	if extra_sprite:
		extra_sprite.material = shader_material
		print("Shader applied to extra sprite")
	else:
		push_warning("Cannot apply shader material: extra_sprite not found!")
	if counter_sprite:
		counter_sprite.material = shader_material
		print("Shader applied to counter sprite")
	else:
		push_warning("ExtraSprite not found!")
	if new_sprite:
		new_sprite.material = shader_material
		print("Shader applied to new sprite")
	else:
		push_warning("Cannot apply shader material: new_sprite not found!")

	# Логіка запуску гри автоматично
	bubble_counter_label.visible = true
	bubble_counter_label.modulate.a = 1.0
	print("Counter label shown: visible=true, modulate.a=1.0")
	counter_sprite.visible = true
	counter_sprite.modulate.a = 1.0
	print("Counter sprite visible: visible=true, modulate.a=1.0")
	third_button.visible = true
	third_button.modulate.a = 1.0
	print("Third button shown: visible=true, modulate.a=1.0")
	level_label.visible = true
	level_label.modulate.a = 1.0
	print("Level label shown: visible=true, modulate.a=1.0")
	create_bubble_grid()
	create_moving_bubble()
	if instruction_label and is_first_game:
		instruction_label.visible = true
		print("Instruction label shown (first game)")
	is_first_game = false

func _input(event: InputEvent) -> void:
	if exit_label and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		if exit_label.get_global_rect().has_point(mouse_pos):
			get_tree().change_scene_to_file("res://Меню.tscn")  # Повернення до першої сцени
			print("Switching back to Меню.tscn via ExitLabel")

func _on_exit_label_input(event: InputEvent) -> void:
	if exit_label and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		var mouse_pos = event.position
		print("Mouse click at: ", mouse_pos, ", ExitLabel rect: ", exit_label.get_global_rect())
		if exit_label.get_global_rect().has_point(mouse_pos):
			print("Click detected inside ExitLabel, switching scene...")
			get_tree().change_scene_to_file("res://Меню.tscn")
		else:
			print("Click outside ExitLabel rect")

func _on_third_button_pressed() -> void:
	if is_instance_valid(current_bubble) and not current_bubble.moving and current_bubble.is_entrance_animation_complete:
		var new_color = bubble_colors[randi() % bubble_colors.size()]
		current_bubble.color = new_color
		current_bubble.queue_redraw()
		print("Moving bubble color changed to: ", new_color)
	else:
		print("Cannot change color: no valid moving bubble or bubble is moving/animating")

func create_bubble_grid() -> void:
	current_level += 1
	if level_label:
		level_label.text = "Рівень: " + str(current_level)
		print("Level label updated: text='Level: ", current_level, "'")
	else:
		push_warning("LevelLabel not found!")
	
	var grid_rows = grid_row_count
	var grid_columns = 15
	var bubble_radius = 32
	var spacing = bubble_radius * 2 + 5
	var row_spacing = bubble_radius * 2 + 5
	var screen_size = get_viewport_rect().size

	var total_grid_width = (grid_columns - 1) * spacing
	var start_x = (screen_size.x - total_grid_width) / 2
	var total_grid_height = (grid_rows - 1) * row_spacing
	var start_y = screen_size.y - total_grid_height - 150

	for y in range(grid_rows):
		for x in range(grid_columns):
			var bubble = StaticBubble.new()
			bubble.color = bubble_colors[randi() % bubble_colors.size()]
			bubble.position = Vector2(start_x + x * spacing, start_y + y * row_spacing)
			add_child(bubble)
			print("Created bubble at: ", bubble.position, ", color=", bubble.color)
# Додавання нового ряду зниизу сітки після трьох ходів без знищення
func add_new_bubble_row() -> void:
	var grid_columns = 15
	var bubble_radius = 32
	var grid_spacing = bubble_radius * 2 + 5
	var row_spacing = bubble_radius * 2 + 5
	var screen_size = get_viewport_rect().size

	var lowest_y = -INF
	for child in get_children():
		if child is StaticBubble and is_instance_valid(child):
			lowest_y = max(lowest_y, child.position.y)
	
	if lowest_y == -INF:
		lowest_y = screen_size.y - 150
	
	var new_row_y = lowest_y + row_spacing

	var additional_shift = 0.0
	if new_row_y + bubble_radius > screen_size.y:
		additional_shift = (new_row_y + bubble_radius) - screen_size.y
		new_row_y -= additional_shift
		var tween = create_tween().set_parallel(true)
		for child in get_children():
			if child is StaticBubble and is_instance_valid(child):
				var new_position = Vector2(child.position.x, child.position.y - additional_shift)
				tween.tween_property(child, "position", new_position, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				print("Tweening bubble from: ", child.position, " to: ", new_position)
		print("New row would be off-screen, shifting grid up by: ", additional_shift, ", new_row_y=", new_row_y)

	var total_grid_width = (grid_columns - 1) * grid_spacing
	var start_x = (screen_size.x - total_grid_width) / 2
	for x in range(grid_columns):
		var child = StaticBubble.new()
		child.color = bubble_colors[randi() % bubble_colors.size()]
		child.position = Vector2(start_x + x * grid_spacing, new_row_y)
		add_child(child)
		print("Added new bubble child at: ", child.position, ", color: ", child.color)

	grid_row_count += 1
	print("Grid row count increased to: ", grid_row_count)
	if extra_sprite:
		extra_sprite.visible = grid_row_count >= 8   # Виведення повідомлення про програш коли на сцені 8 рядів статичних куль 
		if extra_sprite.visible:
			var tween = create_tween().set_parallel(true)
			for child in get_children():
				if child != new_sprite:
					if child is Node2D and is_instance_valid(child):
						tween.tween_property(child, "modulate:a", 0.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
						tween.tween_callback(func(): 
							if is_instance_valid(child):
								if child is StaticBubble or child is MovingBubble:
									child.queue_free()
								else:
									child.visible = false
						).set_delay(0.5)
			print("All elements except NewSprite faded out")
	if new_sprite:
		new_sprite.visible = grid_row_count >= 8
		if new_sprite.visible and new_sprite.modulate.a < 1.0:
			new_sprite.modulate.a = 0.0
			var tween = create_tween()
			tween.tween_property(new_sprite, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			print("New sprite faded in at grid_row_count=", grid_row_count)
		print("New sprite visibility set to: ", new_sprite.visible, " (grid_row_count=", grid_row_count, ")")
	else:
		push_warning("ExtraSprite2 not found!")
	if restart_button:        # Виведення кнопки для того щоб переграти рівень
		restart_button.visible = grid_row_count >= 8
		if restart_button.visible:
			restart_button.modulate.a = 0.0
			var tween = create_tween()
			tween.tween_property(restart_button, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			print("Restart button shown with fade-in at grid_row_count=", grid_row_count)
		else:
			restart_button.modulate.a = 0.0
			restart_button.visible = false
			print("Restart button hidden at grid_row_count=", grid_row_count)
	else:
		push_warning("RestartButton not found!")

func create_moving_bubble() -> void:
	var screen_size = get_viewport_rect().size
	var bubble = MovingBubble.new()
	var start_y = 100.0
	bubble.position = Vector2(screen_size.x / 2, start_y)
	bubble.z_index = 3
	bubble.target_position = Vector2(screen_size.x / 2, start_y + 10)
	bubble.start_position = bubble.position
	bubble.visible = true
 # Виведення повідомлення про виграш, коли кількість куль у сітці дорівнює нулю
	if not has_blue_bubble and bubble_destroyed_count == 0: 
		bubble.color = Color(0, 0, 1)
		has_blue_bubble = true
	else:
		bubble.color = bubble_colors[randi() % bubble_colors.size()]
	
	var static_bubble_count = 0
	for child in get_children():
		if child is StaticBubble:
			static_bubble_count += 1
	bubble.is_last_bubble = (static_bubble_count == 0)
	
	print("Bubble created: color=", bubble.color, ", pos=", bubble.position, ", last_bubble=", bubble.is_last_bubble)
	current_bubble = bubble
	bubble.connect("stopped", Callable(self, "_on_bubble_stopped"))

	add_child(bubble)
	if sprite:
		sprite.visible = true
		sprite.modulate.a = 1.0
		print("Sprite2D2 visible: visible=true, modulate.a=1.0")
	else:
		push_warning("Sprite2D2 not found in create_moving_bubble!")
	var tween = create_tween()
	tween.tween_property(bubble, "position:y", bubble.target_position.y, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween.tween_callback(func(): 
		bubble.is_entrance_animation_complete = true
		static_bubble_count = 0
		for child in get_children():
			if child is StaticBubble:
				static_bubble_count += 1
		print("Static bubble count after entrance: ", static_bubble_count)
	
		if static_bubble_count == 0: #Виведення кнопки для переходу до наступного рівня 
			if third_button:
				third_button.modulate.a = 1.0
				var button_tween = create_tween()
				button_tween.tween_property(third_button, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				button_tween.tween_callback(func(): third_button.visible = false)
				print("Third button fading out before bubble movement")
			else:
				push_warning("Button3 not found!")
			var center_x = screen_size.x / 2
			var center_y = screen_size.y / 2
			var bubble_target_position = Vector2(center_x, center_y - screen_size.y * 0.2)
			var move_tween = create_tween().set_parallel(true)
			bubble.moving = true
			move_tween.tween_property(bubble, "position", bubble_target_position, 1.0).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
			move_tween.tween_callback(func(): 
				print("MovingBubble reached target: ", bubble.position)
				bubble.moving = false
				bubble.velocity = Vector2.ZERO
				if final_label:
					final_label.text = str(bubble_destroyed_count)
					final_label.visible = true
					final_label.modulate.a = 0
					var label_tween = create_tween()
					label_tween.tween_interval(1.0)
					label_tween.tween_property(final_label, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
					label_tween.tween_callback(func(): 
						print("Label3 shown: text=", final_label.text)
						show_celebration()
					)
				else:
					push_warning("Label3 is null!")
					show_celebration()
			))

func _on_bubble_stopped() -> void:
	if is_instance_valid(current_bubble):
		if current_bubble.color == Color(0, 0, 1):
			has_blue_bubble = false
	var static_bubble_count = 0
	for child in get_children():
		if child is StaticBubble:
			static_bubble_count += 1
	print("Bubble count after stop: ", static_bubble_count)
	
	var grid_bubbles_destroyed = false
	if current_bubble and current_bubble.grid_bubbles_destroyed:
		grid_bubbles_destroyed = true
	
	if not grid_bubbles_destroyed:
		moves_without_grid_destruction += 1
		print("No grid bubbles destroyed, moves_without_grid_destruction: ", moves_without_grid_destruction)
	else:
		moves_without_grid_destruction = 0
		print("Grid bubbles destroyed, resetting moves_without_grid_destruction to 0")

	if moves_without_grid_destruction >= 3:
		add_new_bubble_row()
		moves_without_grid_destruction = 0
		print("Added new row of bubbles after 3 moves without grid destruction")

	if static_bubble_count > 0:
		create_moving_bubble()
	else:
		show_celebration()

func show_celebration() -> void:
	print("show_celebration called at ", Time.get_ticks_msec())
	var tween = create_tween().set_parallel(true)

	if bubble_counter_label:
		bubble_counter_label.modulate.a = 1.0
		print("Starting counter label fade-out")
		tween.tween_property(bubble_counter_label, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): bubble_counter_label.visible = false).set_delay(0.3)
		print("Counter label hidden in celebration")
	else:
		push_warning("Label not found!")

	if counter_sprite and sprite:
		counter_sprite.modulate.a = 1.0
		sprite.modulate.a = 1.0
		print("Starting counter sprite and sprite fade-out together")
		tween.tween_property(sprite, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): 
			sprite.visible = false
			print("Sprite hidden together in celebration")
		).set_delay(0.3)
	else:
		if not sprite:
			push_warning("Sprite2D2 not found!")

	if third_button:
		third_button.modulate.a = 1.0
		print("Starting third button fade-out")
		tween.tween_property(third_button, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): third_button.visible = false).set_delay(0.3)
		print("Third button hidden in celebration")
	else:
		push_warning("Button3 not found!")

	if second_button:
		second_button.visible = true
		second_button.modulate.a = 0.0
		print("Starting second button fade-in")
		tween.tween_property(second_button, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		print("Showing second button")
	if link_label:
		link_label.visible = true
		link_label.modulate.a = 0.0
		tween.tween_property(link_label, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		print("Showing link label")
	else:
		push_warning("Button2 not found!")

	if restart_button:
		restart_button.visible = false  # Кнопка керується тільки через add_new_bubble_row()
		restart_button.modulate.a = 0.0
		print("Restart button state managed by grid_row_count")
	else:
		push_warning("RestartButton not found!")

	if celebration_sprite:
		celebration_sprite.visible = true
		celebration_sprite.modulate.a = 0.0
		print("Starting celebration sprite fade-in")
		tween.tween_property(celebration_sprite, "modulate:a", 1.0, 0.5).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		tween.tween_callback(func(): print("Celebration sprite visible")).set_delay(0.5)
		print("Showing celebration sprite")
	else:
		push_warning("Sprite2D4 not found!")

	if extra_sprite:
		extra_sprite.visible = false
		extra_sprite.modulate.a = 0.0
		print("Extra sprite hidden in celebration")
	if new_sprite:
		new_sprite.visible = false
		new_sprite.modulate.a = 0.0
		print("New sprite hidden in celebration")
	else:
		push_warning("ExtraSprite2 not found!")

func find_connected_bubbles(start_bubble: StaticBubble, color: Color) -> Array:
	var connected_bubbles = []
	var to_check = [start_bubble]
	var checked = []

	while to_check:
		var bubble = to_check.pop_front()
		if bubble in checked:
			continue
		checked.append(bubble)
		if not is_instance_valid(bubble) or bubble.color != color:
			continue
		connected_bubbles.append(bubble)

		for child in get_children():
			if child is StaticBubble and child not in checked:
				var distance = bubble.position.distance_to(child.position)
				var collision_distance = bubble.radius + child.radius + 5
				if distance <= collision_distance:
					if child.color == color:
						to_check.append(child)
						print("Found connected bubble at: ", child.position, ", distance: ", distance)

	return connected_bubbles

func remove_connected_bubbles(start_bubble: StaticBubble, moving_bubble: MovingBubble, color: Color) -> void:
	var connected_bubbles = find_connected_bubbles(start_bubble, color)
	var static_bubble_count = 0

	for bubble in get_children():
		if bubble is StaticBubble:
			static_bubble_count += 1

	var tween = create_tween().set_parallel(true)

	if connected_bubbles.size() >= 2:
		for bubble in connected_bubbles:
			tween.tween_property(bubble, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(bubble, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_callback(func():
				if is_instance_valid(bubble):
					bubble.queue_free()
					print("Bubble removed at: ", bubble.position)
			).set_delay(0.3)

		if is_instance_valid(moving_bubble):
			tween.tween_property(moving_bubble, "scale", Vector2.ZERO, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_property(moving_bubble, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			tween.tween_callback(func():
				if is_instance_valid(moving_bubble):
					moving_bubble.queue_free()
					print("MovingBubble removed at: ", moving_bubble.position)
			).set_delay(0.3)

		var bubbles_removed = connected_bubbles.size() + 1
		bubble_destroyed_count += bubbles_removed
		if bubble_counter_label:
			bubble_counter_label.text = str(bubble_destroyed_count)
			print("Updated bubble_destroyed_count: ", bubble_destroyed_count)

		if is_instance_valid(moving_bubble):
			moving_bubble.grid_bubbles_destroyed = true

		if static_bubble_count == connected_bubbles.size():
			if bubble_counter_label:
				print("Hiding counter_label")
				tween.tween_property(bubble_counter_label, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_callback(func(): bubble_counter_label.visible = false).set_delay(0.3)
			else:
				push_warning("CounterLabel not found!")
			if sprite:
				print("Hiding sprite")
				tween.tween_property(sprite, "modulate:a", 0.0, 0.3).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
				tween.tween_callback(func():
					sprite.visible = false
					print("Sprite fade-out at ", Time.get_ticks_msec())
				).set_delay(0.3)
			else:
				push_warning("Sprite2D2 not found!")
	else:
		var new_static_bubble = StaticBubble.new()
		new_static_bubble.color = color
		new_static_bubble.position = moving_bubble.position
		add_child(new_static_bubble)
		print("MovingBubble converted to StaticBubble at: ", new_static_bubble.position, ", color: ", color)
		if is_instance_valid(moving_bubble):
			moving_bubble.queue_free()
			print("MovingBubble removed at: ", moving_bubble.position)

	_check_remaining_bubbles()

func _check_remaining_bubbles() -> void:
	var static_bubble_count = 0
	for child in get_children():
		if child is StaticBubble:
			static_bubble_count += 1
	print("Remaining static bubbles: ", static_bubble_count)

func _on_second_button_pressed() -> void:
	reset_game()
	print("Second button pressed, starting new game!")

func _on_restart_button_pressed() -> void:
	reset_level()
	print("Restart button pressed, resetting level")

func reset_game() -> void:
	for child in get_children():
		if child is StaticBubble or child is MovingBubble:
			child.queue_free()
			print("Removed bubble at: ", child.position)

	bubble_destroyed_count = 0
	has_blue_bubble = false
	moves_without_grid_destruction = 0
	grid_row_count = 4
	if bubble_counter_label:
		bubble_counter_label.text = "0"
		bubble_counter_label.visible = true
		bubble_counter_label.modulate.a = 1.0
		bubble_counter_label.add_theme_font_size_override("font_size", 24)
		bubble_counter_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		bubble_counter_label.add_theme_constant_override("outline_size", 2)
		print("Counter label reset: text=0, visible=true, modulate.a=1.0")
	else:
		print("Label not found!")
	
	if level_label:
		current_level = 1
		level_label.text = "Рівень: " + str(current_level)
		level_label.visible = true
		level_label.modulate.a = 1.0
		print("Level label reset: text='Level: ", current_level, "', visible=true, modulate.a=1.0")
	else:
		print("LevelLabel not found!")

	if celebration_sprite:
		celebration_sprite.visible = false
		celebration_sprite.modulate.a = 0.0
		print("Celebration sprite hidden")
	else:
		push_warning("Sprite2D4 not found!")

	if second_button:
		second_button.visible = false
		second_button.modulate.a = 0.0
		print("Second button hidden")
	if link_label:
		link_label.visible = false
		link_label.modulate.a = 0.0
		print("Link label hidden")
	else:
		push_warning("Button2 not found!")

	if third_button:
		third_button.visible = true
		third_button.modulate.a = 1.0
		print("Third button reset: visible=true, modulate.a=1.0")
	else:
		push_warning("Button3 not found!")

	if final_label:
		final_label.visible = false
		final_label.modulate.a = 0.0
		final_label.text = ""
		print("Final label hidden")
	else:
		push_warning("Label3 not found!")

	if sprite:
		sprite.visible = true
		sprite.modulate.a = 1.0
		print("Sprite2D2 set: visible=true, modulate.a=1.0")
	else:
		push_warning("Sprite2D2 not found!")

	if extra_sprite:
		extra_sprite.visible = false
		extra_sprite.modulate.a = 0.0
		print("Extra sprite reset: visible=false, modulate.a=0.0")
	if new_sprite:
		new_sprite.visible = false
		new_sprite.modulate.a = 0.0
		print("New sprite reset: visible=false, modulate.a=0.0")
	else:
		push_warning("ExtraSprite2 not found!")

	if restart_button:
		restart_button.visible = false
		restart_button.modulate.a = 0.0
		print("Restart button reset: visible=false, modulate.a=0.0")
	else:
		push_warning("RestartButton not found!")

	if exit_label:
		exit_label.visible = true
		exit_label.modulate.a = 1.0
		print("Exit label reset: visible=true, modulate.a=1.0")
	else:
		push_warning("ExitLabel not found!")

	create_bubble_grid()
	create_moving_bubble()
	print("New game started with reset count: ", bubble_destroyed_count, ", level: ", current_level)

func reset_level() -> void:
	for child in get_children():
		if child is StaticBubble or child is MovingBubble:
			child.queue_free()
			print("Removed bubble at: ", child.position)

	if is_instance_valid(current_bubble):
		current_bubble.queue_free()
		print("Removed current moving bubble")

	moves_without_grid_destruction = 0
	grid_row_count = 4
	if bubble_counter_label:
		bubble_counter_label.text = "0"
		bubble_counter_label.visible = true
		bubble_counter_label.modulate.a = 1.0
		bubble_counter_label.add_theme_font_size_override("font_size", 24)
		bubble_counter_label.add_theme_color_override("font_outline_color", Color(0, 0, 0))
		bubble_counter_label.add_theme_constant_override("outline_size", 2)
		print("Counter label reset: text=0, visible=true, modulate.a=1.0")
	else:
		print("Label not found!")
	
	if level_label:
		level_label.visible = true
		level_label.modulate.a = 1.0
		print("Level label reset: visible=true, modulate.a=1.0")
	else:
		print("LevelLabel not found!")

	if celebration_sprite:
		celebration_sprite.visible = false
		celebration_sprite.modulate.a = 0.0
		print("Celebration sprite hidden")
	else:
		push_warning("Sprite2D4 not found!")

	if second_button:
		second_button.visible = false
		second_button.modulate.a = 0.0
		print("Second button hidden")
	if link_label:
		link_label.visible = false
		link_label.modulate.a = 0.0
		print("Link label hidden")
	else:
		push_warning("Button2 not found!")

	if third_button:
		third_button.visible = true
		third_button.modulate.a = 1.0
		print("Third button reset: visible=true, modulate.a=1.0")
	else:
		push_warning("Button3 not found!")

	if final_label:
		final_label.visible = false
		final_label.modulate.a = 0.0
		final_label.text = ""
		print("Final label hidden")
	else:
		push_warning("Label3 not found!")

	if sprite:
		sprite.visible = true
		sprite.modulate.a = 1.0
		print("Sprite2D2 set: visible=true, modulate.a=1.0")
	else:
		push_warning("Sprite2D2 not found!")

	if extra_sprite:
		extra_sprite.visible = false
		extra_sprite.modulate.a = 0.0
		print("Extra sprite reset: visible=false, modulate.a=0.0")
	if new_sprite:
		new_sprite.visible = false
		new_sprite.modulate.a = 0.0
		print("New sprite reset: visible=false, modulate.a=0.0")
	else:
		push_warning("ExtraSprite2 not found!")

	if restart_button:
		restart_button.visible = false
		restart_button.modulate.a = 0.0
		print("Restart button reset: visible=false, modulate.a=0.0")
	else:
		push_warning("RestartButton not found!")

	if exit_label:
		exit_label.visible = true
		exit_label.modulate.a = 1.0
		print("Exit label reset: visible=true, modulate.a=1.0")
	else:
		push_warning("ExitLabel not found!")

	create_bubble_grid()
	create_moving_bubble()
	print("Level reset with count: ", bubble_destroyed_count, ", level: ", current_level)

class StaticBubble extends Node2D:   # Створення статичної сітки
	var radius: int = 32
	var color: Color = Color(1, 0, 0)
	
	func _draw() -> void:
		draw_circle(Vector2.ZERO, radius, color)

class MovingBubble extends Node2D: # Рухомі кулі
	signal stopped
	var radius: float = 32.0
	var max_radius: float = 48.0
	var radius_growth_rate: float = 10.0
	var is_last_bubble: bool = false
	var color: Color = Color(1, 0, 0)
	var speed: float = 300.0
	var moving: bool = false
	var start_position: Vector2
	var target_position: Vector2
	var is_entrance_animation_complete: bool = false
	var grid_bubbles_destroyed: bool = false

	var drag_start_position: Vector2
	var drag_end_position: Vector2
	var velocity: Vector2 = Vector2.ZERO

	func _input(event):
		if not is_entrance_animation_complete:
			return

		if event is InputEventMouseButton:  #  Функція задавання мишею, напрямку для куоі
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					drag_start_position = event.position
				else:
					drag_end_position = event.position
					var direction = (drag_end_position - drag_start_position).normalized()
					if direction.length() > 0.1:
						move_in_direction(direction)
						if get_parent().instruction_label:
							get_parent().instruction_label.visible = false
						print("Drag detected, moving: ", direction)

	func move_in_direction(direction: Vector2) -> void:
		velocity = direction * speed
		moving = true
		print("Moving set to true, velocity: ", velocity)

	func _process(delta):
		if moving and is_entrance_animation_complete:
			if is_last_bubble and radius < max_radius:
				radius += radius_growth_rate * delta
				radius = min(radius, max_radius)
				queue_redraw()
				print("MovingBubble radius: ", radius, ", last_bubble: ", is_last_bubble, ", moving: ", moving)
			position += velocity * delta
			check_collision()

	func check_collision() -> void:
		var screen_size = get_viewport_rect().size
		if position.x < radius or position.x > screen_size.x - radius or position.y < radius or position.y > screen_size.y - radius:
			moving = false
			emit_signal("stopped")
			queue_free()
			print("Collision with screen edge, moving: ", moving)
			return

		for child in get_parent().get_children():
			if child is StaticBubble and is_instance_valid(child):
				var distance = position.distance_to(child.position)
				var collision_distance = radius + child.radius + 5
				if distance <= collision_distance:
					if child.color == color:
						var connected_bubbles = get_parent().find_connected_bubbles(child, color)
						if connected_bubbles.size() >= 1:
							get_parent().remove_connected_bubbles(child, self, color)
					else:
						var new_static_bubble = StaticBubble.new()
						new_static_bubble.color = color
						new_static_bubble.position = self.position
						get_parent().add_child(new_static_bubble)
						print("MovingBubble converted to StaticBubble at: ", new_static_bubble.position, ", color: ", color)
					
					moving = false
					emit_signal("stopped")
					queue_free()
					return

	func _draw() -> void:
		draw_circle(Vector2.ZERO, radius, color)
