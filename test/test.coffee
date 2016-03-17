
parse_tabs = require "../tablature-parser.coffee"
{expect} = require "chai"

parse = (tabs, {to: expected_notes})->
	parsed_notes = parse_tabs(tabs)
	expect(parsed_notes).to.eql(expected_notes)

describe "the tab parser", ->
	it "should parse EADGBe", ->
		parse """
			e|---
			B|-1-
			G|---
			D|---
			A|---
			E|---
		""", to:
			[
				[s: 1, f: 1]
			]
	it "should parse EADGBE as EADGBe", ->
		parse """
			E|-----------------------------
			B|-0-2-3-5-2-3-0-0-2-3-5-2-3-7-
			G|-----------------------------
			D|-----------------------------
			A|-----------------------------
			E|-----------------------------
		""", to:
			[
				[s: 1, f: 0]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 5]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 0]
				[s: 1, f: 0]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 5]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 7]
			]
	it "should parse eadgbe as EADGBe", ->
		parse """
			e|---
			b|-1-
			g|---
			d|---
			a|---
			e|---
		""", to:
			[
				[s: 1, f: 1]
			]
	it "should parse multiple blocks", ->
		parse """
			E|-----------------------------
			B|-0-2-3-5-2-3-0-0-2-3-5-2-3-7-
			G|-----------------------------
			D|-----------------------------
			A|-----------------------------
			E|-----------------------------
			
			E|------------------------------
			B|0-2-3-3-5-3-2-2-3-2-0-0-0---0-
			G|--------------------------2---
			D|------------------------------
			A|------------------------------
			E|------------------------------
		""", to:
			[
				[s: 1, f: 0]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 5]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 0]
				[s: 1, f: 0]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 5]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 7]
				
				[s: 1, f: 0]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 3]
				[s: 1, f: 5]
				[s: 1, f: 3]
				[s: 1, f: 2]
				[s: 1, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 2]
				[s: 1, f: 0]
				[s: 1, f: 0]
				[s: 1, f: 0]
				[s: 2, f: 2]
				[s: 1, f: 0]
			]
	it.skip "should parse a block without any string names as EADGBe", ->
		parse """
			---
			-1-
			---
			---
			---
			---
		""", to:
			[
				[s: 1, f: 1]
			]
	it "should parse blocks following a block with string names as the same as the above"
	it "should parse or throw an error at other tunings"
	it "should throw an error when no blocks are found"
	it "should throw an error when a block doesn't line up (or actually... see the next test)"
	it "should ignore text above, below, and beside blocks"
	it "should ignore various articulations like bends and hammer-ons (for now at least)"
	it "should handle tabs with multi-digit numbers"
	it "should handle tabs with squished together single digit numbers"
	# it "should parse chords"
	# it "should parse chords with multi-digit numbers"
	it "should throw some other errors"
	it "should probably always return arrays (i.e. chords of one note)"


format_notes_for_test_code = (chords)->
	note_chord_coffees =
		for chord in chords
			note_coffees =
				for note in chord
					props_coffee = "s: #{note.s}, f: #{note.f}"
					if chord.length > 1 then "{#{props_coffee}}" else props_coffee
			"[#{note_coffees}]"
	
	"""
		[
			#{note_chord_coffees.join "\n\t"}
		]
	"""

# i.e. console.log format_notes_for_test_code [
#   {
#     "f": 0
#     "s": 1
#   }
# ]
