extends SceneTree
## Draws every glyph, and a few lines of text, onto docs/specimen.png: what the README shows.
## Run with: tools/test.sh specimen

const SCALE := 4
const LINES: Array[String] = [
	"Itrium Pixel",
	"ABCDEFGHIJKLMNOPQRSTUVWXYZ",
	"abcdefghijklmnopqrstuvwxyz",
	"0123456789 .,:;!?'\"-+=/()%°×<>→←",
	"The quick brown fox jumps over the lazy cat.",
]
const INK := Color8(242, 242, 242)
const PAPER := Color8(43, 43, 43)
const ACCENT := Color8(254, 191, 202)


func _init() -> void:
	var arguments := OS.get_cmdline_user_args()
	var output := arguments[0] if not arguments.is_empty() else "user://specimen.png"
	var width := 0
	for line in LINES:
		width = maxi(width, PixelFont.width(line))
	var image := Image.create_empty(width + 16, LINES.size() * PixelFont.LINE_HEIGHT + 12, false, Image.FORMAT_RGBA8)
	image.fill(PAPER)
	for index in LINES.size():
		_write(image, Vector2i(8, 6 + index * PixelFont.LINE_HEIGHT), LINES[index], ACCENT if index == 0 else INK)
	image.resize(image.get_width() * SCALE, image.get_height() * SCALE, Image.INTERPOLATE_NEAREST)
	image.save_png(output)
	print("specimen written to ", output)
	quit()


func _write(image: Image, at: Vector2i, text: String, color: Color) -> void:
	var x := at.x
	for character in text:
		if character == " ":
			x += PixelFont.SPACE_WIDTH + PixelFont.LETTER_SPACING
			continue
		var rows := PixelFont.glyph_rows(character if PixelFont.GLYPHS.has(character) else "?")
		for y in rows.size():
			for column in rows[y].length():
				if rows[y][column] == "#":
					image.set_pixel(x + column, at.y + y, color)
		x += rows[0].length() + PixelFont.LETTER_SPACING
