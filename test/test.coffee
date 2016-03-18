
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
	
	it "should treat a block with 6 unnamed strings as EADGBe by default", ->
		# or as unknown?
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
	
	it.skip "should treat a block with 4 unnamed strings as EADG by default", ->
		# or as unknown?
		parse """
			---
			-1-
			---
			---
		""", to:
			[
				[s: 1, f: 1]
			]
	
	it.skip "should treat a block without any string names as the same as any blocks above", ->
		parse """
			e -------------------------5-7-9--
			B --------------------5-6-8-------
			G ---------------4-5-7------------
			D ------------5-7-----------------
			A -------5-7-8--------------------
			D -7-9-10-------------------------
			
			---------------------------5-7-9--
			----------------------5-7-9-------
			-----------------6-7-9------------
			------------6-7-9-----------------
			-------5-7-9----------------------
			-7-9-11---------------------------
		""", to:
			[
			]
	
	it "should handle or throw an error at other tunings", ->
		expect(->
			parse_tabs """
				e -------------------------5-7-9--
				B --------------------5-6-8-------
				G ---------------4-5-7------------
				D ------------5-7-----------------
				A -------5-7-8--------------------
				D -7-9-10-------------------------
			"""
		).to.throw("Alternate tunings such as eBGDAD are not supported (yet)")
	
	it "should handle or throw an error at bass tablature", ->
		expect(->
			parse_tabs """
				G|---------------------------------------------------|
				D|----------------99------99------77667766-----------|
				A|-77------77--------11-9----11-9----------777-------|
				E|----9-7-----9-7------------------------------9777--|
			"""
		).to.throw("Bass tablature is not supported (yet)")
	
	it "should throw an error when no blocks are found", ->
		expect(->
			parse_tabs "(nothing here)"
		).to.throw("no music blocks found")
	
	it "should ignore text above, below, and beside blocks", ->
		parse """
			Intro pieces of lard
			E|2-----2-4-5-4---2-----2-0-
			B|--3-----------3-----3----- X5
			G|----2-------------2-------
			D|-------------------------- (note: play like a b4d@$$)
			A|-------------------------- (but fairly straightforward)
			E|--------------------------
			lryics go "uuuuuuuugh uh pshh um space dinosaurs"
			yeah sounds legit
		""", to:
			[
				[s: 0, f: 2]
				[s: 1, f: 3]
				[s: 2, f: 2]
				[s: 0, f: 2]
				[s: 0, f: 4]
				[s: 0, f: 5]
				[s: 0, f: 4]
				[s: 1, f: 3]
				[s: 0, f: 2]
				[s: 2, f: 2]
				[s: 1, f: 3]
				[s: 0, f: 2]
				[s: 0, f: 0]
			]
	
	it "should throw an error when a block doesn't line up", ->
		expect(->
			parse """
				e--------------
				B-1-3-1---------
				G----------------
				D----------------
				A---------------
				E--------------
			""", to:
				[
					[s: 1, f: 1]
					[s: 1, f: 3]
					[s: 1, f: 1]
				]
		).to.throw("""
			e-------------- <<
			B-1-3-1--------- <<
			G---------------- <<
			D---------------- <<
			A--------------- <<
			E-------------- <<
		""")
	
	it "should throw a proper error when part of a block doesn't line up but when some text can be ignored", ->
		expect(->
			parse_tabs """
				Intro pieces of lard
				E|2-----2-4-5-4---2-----2-0-
				B|--3-----------3-----3-----X5
				G|----2-------------2-------
				D|-------------------------- (note: play like a b4d@$$)
				A|-------------------------- (but fairly straightforward)
				E|--------------------------
			"""
		).to.throw("""
				E|2-----2-4-5-4---2-----2-0- <<
				B|--3-----------3-----3-----X5 <<
				G|----2-------------2------- <<
				D|-------------------------- << (note: play like a b4d@$$)
				A|-------------------------- << (but fairly straightforward)
				E|-------------------------- <<
		""")
	
	it "should handle tabs with multi-digit fret numbers", ->
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
	
	it "should handle tabs with squished together single digit numbers", ->
		parse """
			Ievan Polkka (all squished up tho)
			
			E -00230032--2300-002300375323000
			B 0--------33----0---------------
			G -------------------------------
			D -------------------------------
			A -------------------------------
			E -------------------------------
		""", to:
			[
				[s: 1, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 2]
				[s: 0, f: 3]
				[s: 0, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 3]
				[s: 0, f: 2]
				[s: 1, f: 3]
				[s: 1, f: 3]
				[s: 0, f: 2]
				[s: 0, f: 3]
				[s: 0, f: 0]
				[s: 0, f: 0]
				[s: 1, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 2]
				[s: 0, f: 3]
				[s: 0, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 3]
				[s: 0, f: 7]
				[s: 0, f: 5]
				[s: 0, f: 3]
				[s: 0, f: 2]
				[s: 0, f: 3]
				[s: 0, f: 0]
				[s: 0, f: 0]
				[s: 0, f: 0]
			]
	
	it "should parse chords with multi-digit fret numbers", ->
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
	
	it "should parse chords with squished together single digit numbers", ->
		parse """
			e-00-000--------------------------------------------------------------------|
			B—00-000-33-----------------------------------------------------------------|
			G-11-111-22—2222------------------------------------------------------------|
			D-22-222-00-2222------------------------------------------------------------|
			A-22-222----0000------------------------------------------------------------|
			E-00-000--------------------------------------------------------------------|
		""", to:
			[
				[{s: 5, f: 0},{s: 4, f: 2},{s: 3, f: 2},{s: 2, f: 1},{s: 1, f: 0},{s: 0, f: 0}]
				[{s: 5, f: 0},{s: 4, f: 2},{s: 3, f: 2},{s: 2, f: 1},{s: 1, f: 0},{s: 0, f: 0}]
				[{s: 5, f: 0},{s: 4, f: 2},{s: 3, f: 2},{s: 2, f: 1},{s: 1, f: 0},{s: 0, f: 0}]
				[{s: 5, f: 0},{s: 4, f: 2},{s: 3, f: 2},{s: 2, f: 1},{s: 1, f: 0},{s: 0, f: 0}]
				[{s: 5, f: 0},{s: 4, f: 2},{s: 3, f: 2},{s: 2, f: 1},{s: 1, f: 0},{s: 0, f: 0}]
				[{s: 3, f: 0},{s: 2, f: 2},{s: 1, f: 3}]
				[{s: 3, f: 0},{s: 2, f: 2},{s: 1, f: 3}]
				[{s: 4, f: 0},{s: 3, f: 2},{s: 2, f: 2}]
				[{s: 4, f: 0},{s: 3, f: 2},{s: 2, f: 2}]
				[{s: 4, f: 0},{s: 3, f: 2},{s: 2, f: 2}]
				[{s: 4, f: 0},{s: 3, f: 2},{s: 2, f: 2}]
			]
	
	it "should allow empty musical compositions", ->
		parse """
			"The Misinterpretation of Silence and its Disastrous Consequences" by Type O Negative
			
			-----------------------------------
			-----------------------------------
			-----------------------------------
			-----------------------------------
			-----------------------------------
			-----------------------------------
		""", to: []

	it "should ignore various articulations like bends and hammer-ons (for now at least)", ->
		parse """
			e|--8~------------------------------8---10b11-11b10-10-8----8--13/8-|
			B|-----10-8-8/10-8-------------8-10----------------------10---------|
			G|-----------------9-7-5~--5/9--------------------------------------|
			D|------------------------------------------------------------------|
			A|------------------------------------------------------------------|
			E|------------------------------------------------------------------|
		""", to:
			[
				[s: 0, f: 8]
				[s: 1, f: 10]
				[s: 1, f: 8]
				[s: 1, f: 8]
				[s: 1, f: 10]
				[s: 1, f: 8]
				[s: 2, f: 9]
				[s: 2, f: 7]
				[s: 2, f: 5]
				[s: 2, f: 5]
				[s: 2, f: 9]
				[s: 1, f: 8]
				[s: 1, f: 10]
				[s: 0, f: 8]
				[s: 0, f: 10]
				[s: 0, f: 11]
				[s: 0, f: 11]
				[s: 0, f: 10]
				[s: 0, f: 10]
				[s: 0, f: 8]
				[s: 1, f: 10]
				[s: 0, f: 8]
				[s: 0, f: 13]
				[s: 0, f: 8]
			]
	
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
	
	"""
		[
			#{note_chord_coffees.join "\n\t"}
		]
	"""
