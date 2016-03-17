
parse_tabs = require "../tablature-parser.coffee"
{expect} = require "chai"

parse = (tabs, {to: expected_notes})->
	parsed_notes = parse_tabs(tabs)
	try
		format(parsed_notes)
		format(expected_notes)
	catch
		expect(parsed_notes).to.eql(expected_notes)
		return
	expect(format(parsed_notes)).to.eql(format(expected_notes))

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
	it "should handle tabs with multi-digit numbers", ->
		parse """
			e---15---13-11--------------------11-13------------------
			B--------------15-11--------13-15-------15---------------
			G--------------------12----------------------------------
			D--------------------------------------------------------
			A--------------------------------------------------------
			E--------------------------------------------------------
		""", to:
			[
				[s: 0, f: 15]
				[s: 0, f: 13]
				[s: 0, f: 11]
				[s: 1, f: 15]
				[s: 1, f: 11]
				[s: 2, f: 12]
				[s: 1, f: 13]
				[s: 1, f: 15]
				[s: 0, f: 11]
				[s: 0, f: 13]
				[s: 1, f: 15]
			]
	
	it.skip "should handle tabs with squished together single digit numbers", ->
	
	it "should parse chords with multi-digit numbers", ->
		parse """
			 { B   C                           E   F F    }
			e|--------------------------------------------|
			B|--------------------------------------------|
			G|-4---5---------------------------9--10-10---|
			D|-4---5---------------------------9--10-10---|
			A|-2---3---------------------------7---8-8----|
			E|--------------------------------------------|
		""", to:
			[
				[{s: 4, f: 2},{s: 3, f: 4},{s: 2, f: 4}]
				[{s: 4, f: 3},{s: 3, f: 5},{s: 2, f: 5}]
				[{s: 4, f: 7},{s: 3, f: 9},{s: 2, f: 9}]
				[{s: 4, f: 8},{s: 3, f: 10},{s: 2, f: 10}]
				[{s: 4, f: 8},{s: 3, f: 10},{s: 2, f: 10}]
			]
	
	it.skip "should parse chords with squished together single digit numbers", ->
		parse """
			e-00-000--------------------------------------------------------------------|
			B—00-000-33-----------------------------------------------------------------|
			G-11-111-22—2222------------------------------------------------------------|
			D-22-222-00-2222------------------------------------------------------------|
			A-22-222----0000------------------------------------------------------------|
			E-00-000--------------------------------------------------------------------|
		""", to:
			[
			]
	
	it "should throw some other errors"
	it "should probably always return arrays (i.e. chords of one note)"
	it "should parse slides by adding a property slideFrom to the second note (both / and \\)"
	it "should parse hammer-ons by adding a property hammerOn to the second note"
	it "should parse pull-offs by adding a property pullOff to the second note"
	it "should parse vibrato by adding a property vibrato to the note"


format = (chords)->
	throw new Error "Can't format notes" unless chords instanceof Array
	note_chord_coffees =
		for chord in chords
			throw new Error "Can't format notes" unless chord instanceof Array
			note_coffees =
				for note in chord
					throw new Error "Can't format notes" unless note instanceof Object
					props_coffee = "s: #{note.s}, f: #{note.f}"
					if chord.length > 1 then "{#{props_coffee}}" else props_coffee
			"[#{note_coffees}]"
	
	# if valid
	"""
		[
			#{note_chord_coffees.join "\n\t"}
		]
	"""
	# else
	# 	JSON.stringify(chords, null, 2)

# i.e. console.log format [[
#   {
#     "f": 0
#     "s": 1
#   }
# ]]
