extends TestCase
## Glyphs are typed by hand, so a dropped dot or row would silently misdraw a letter.

## Every character the games print, symbols included. A game that needs a new one adds it here
## with the glyph, so nothing falls back to a question mark.
const NEEDED := "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789.,:;!?'\"-+/()%°×<>→←"


func test_every_glyph_is_a_clean_rectangle() -> void:
	for character: String in PixelFont.GLYPHS:
		var rows := PixelFont.glyph_rows(character)
		check(rows.size() == PixelFont.ASCENT or rows.size() == PixelFont.HEIGHT,
			"%s has %d rows" % [character, rows.size()])
		for row in rows:
			check(row.length() == rows[0].length(), "%s has rows of different widths" % character)
			check(row.replace("#", "").replace(".", "").is_empty(), "%s has a stray character" % character)


func test_every_glyph_has_ink() -> void:
	for character: String in PixelFont.GLYPHS:
		check(PixelFont.GLYPHS[character].contains("#"), "%s is blank" % character)


func test_nothing_the_games_print_falls_back_to_a_question_mark() -> void:
	for character in NEEDED:
		check(PixelFont.GLYPHS.has(character), "no glyph for %s" % character)


func test_width_adds_letter_spacing_between_glyphs() -> void:
	check(PixelFont.width("I") == 3, "I was %d wide" % PixelFont.width("I"))
	check(PixelFont.width("II") == 7, "II was %d wide" % PixelFont.width("II"))
	check(PixelFont.width("") == 0, "empty text had width")


func test_it_builds_a_font_for_godot_interfaces() -> void:
	var font := PixelFont.font()
	check(font != null, "no font was built")
	check(font.fixed_size == PixelFont.HEIGHT, "the font is %d pixels, not %d" % [font.fixed_size, PixelFont.HEIGHT])
