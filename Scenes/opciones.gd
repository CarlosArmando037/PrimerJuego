extends Popup

# === NODOS ===
@onready var general_slider = $Panel/ScrollContainer/BoxContainer/AjustesSonido/GridContainer/GeneralHSlider
@onready var musica_slider = $Panel/ScrollContainer/BoxContainer/AjustesSonido/GridContainer/MusicaHSlider
@onready var efectos_slider = $Panel/ScrollContainer/BoxContainer/AjustesSonido/GridContainer/EfectosHSlider

@onready var resolucion_option = $Panel/ScrollContainer/BoxContainer/Gráficos/GridContainer/OptionButton
@onready var modo_option = $Panel/ScrollContainer/BoxContainer/Gráficos/GridContainer/OptionButton2

@onready var back_button = $Panel/AtrasButton

# === ARCHIVO DE CONFIGURACIÓN ===
const CONFIG_PATH = "user://settings.cfg"
var config = ConfigFile.new()

# === READY ===
func _ready():
	populate_options()
	load_settings()
	connect_signals()

# === CARGAR CONFIGURACIONES ===
func load_settings():
	var err = config.load(CONFIG_PATH)
	if err != OK:
		print("No se encontró archivo de configuración, usando valores predeterminados.")
		return

	# Volúmenes
	general_slider.value = config.get_value("audio", "general", 1.0)
	musica_slider.value = config.get_value("audio", "musica", 1.0)
	efectos_slider.value = config.get_value("audio", "efectos", 1.0)

	# Gráficos
	var res = config.get_value("video", "resolucion", "1920x1080")
	var modo = config.get_value("video", "modo", "Ventana")

	set_resolution(res)
	set_window_mode(modo)

	# Seleccionar visualmente las opciones
	select_option_by_text(resolucion_option, res)
	select_option_by_text(modo_option, modo)

# === GUARDAR CONFIGURACIONES ===
func save_settings():
	config.set_value("audio", "general", general_slider.value)
	config.set_value("audio", "musica", musica_slider.value)
	config.set_value("audio", "efectos", efectos_slider.value)
	config.set_value("video", "resolucion", resolucion_option.get_item_text(resolucion_option.selected))
	config.set_value("video", "modo", modo_option.get_item_text(modo_option.selected))
	config.save(CONFIG_PATH)

# === CONECTAR SEÑALES ===
func connect_signals():
	general_slider.connect("value_changed", Callable(self, "_on_general_changed"))
	musica_slider.connect("value_changed", Callable(self, "_on_musica_changed"))
	efectos_slider.connect("value_changed", Callable(self, "_on_efectos_changed"))
	resolucion_option.connect("item_selected", Callable(self, "_on_resolucion_selected"))
	modo_option.connect("item_selected", Callable(self, "_on_modo_selected"))

# === POBLAR OPCIONES ===
func populate_options():
	var resoluciones = ["1280x720", "1600x900", "1920x1080", "2560x1440"]
	for res in resoluciones:
		resolucion_option.add_item(res)

	var modos = ["Ventana", "Pantalla completa", "Sin bordes"]
	for m in modos:
		modo_option.add_item(m)

# === SLIDERS ===
func _on_general_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	save_settings()

func _on_musica_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value))
	save_settings()

func _on_efectos_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value))
	save_settings()

# === OPCIONES GRÁFICAS ===
func _on_resolucion_selected(index):
	var res_text = resolucion_option.get_item_text(index)
	match res_text:
		"1280x720":
			set_resolution("1280x720")
		"1600x900":
			set_resolution("1600x900")
		"1920x1080":
			set_resolution("1920x1080")
		"2560x1440":
			set_resolution("2560x1440")
	save_settings()

func _on_modo_selected(index):
	var modo = modo_option.get_item_text(index)
	set_window_mode(modo)
	save_settings()

# === FUNCIONES AUXILIARES ===
func set_resolution(res_str: String):
	var parts = res_str.split("x")
	if parts.size() == 2:
		var width = int(parts[0])
		var height = int(parts[1])
		DisplayServer.window_set_size(Vector2i(width, height))

func set_window_mode(mode: String):
	match mode:
		"Ventana":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		"Pantalla completa":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func select_option_by_text(option_button: OptionButton, text: String):
	for i in range(option_button.item_count):
		if option_button.get_item_text(i) == text:
			option_button.select(i)
			break

# === BOTONES ===
func _on_atras_button_pressed():
	hide()  # Solo ocultamos el Popup

# === BOTÓN ATRÁS ===
func _on_button_regresar_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/ui.tscn")
