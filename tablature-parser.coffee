
parseTabs = (str)->
	
	noteStrings = {E:"",A:"",D:"",G:"",B:"",e:""}
	tuning = "eBGDAE"
	
	# @TODO: avoid using regular expressions as they can't hardly be optimized
	# and they can crash on some inputs (@FIXME)
	# (This code could also be DRYed quite a bit)
	
	# find sections of lines prefixed by string names
		# (minimum of one dash in each line)
	EBGDAE = ///
		E([^\n]*-[^\n]*)\n
		B([^\n]*-[^\n]*)\n
		G([^\n]*-[^\n]*)\n
		D([^\n]*-[^\n]*)\n
		A([^\n]*-[^\n]*)\n
		E([^\n]*-[^\n]*)
	///gim
	str.replace EBGDAE, (block)->
		# console.log "EBGDAE block found:\n#{block}"
		lines = block.split("\n")
		for line, i in lines
			# if line.length != lines[0].length
				# @TODO: throw error here
			
			m = line.match(/^\s*(\w)\s*(.*)$/)
			stringName = m[1].toUpperCase()
			someNotes = m[2].trim()
			
			if stringName is "E" and i is 0
				stringName = "e"
			
			noteStrings[stringName] += someNotes # STRING the notes together HAHAHAHAHAHAHAHA um
		
		"{...}"
	
	# fallback to ....wait won't this play incorrectly anyways? uhhh hmmm
	if noteStrings.B.length is 0
		# (minimum of three dashes in each line)
		AnyBlocks = ///
			((\w)([^\n]*-[^\n]*-[^\n]*-[^\n]*)\n){2,5}
			(\w)([^\n]*-[^\n]*-[^\n]*-[^\n]*)
		///gim
		str.replace AnyBlocks, (block)->
			console.log "Music block found:\n#{block}"
			lines = block.split("\n")
			for line, i in lines
				m = line.match(/^\s*(\w)\s*(.*)$/)
				stringName = m[1].toUpperCase()
				someNotes = m[2].trim()
				
				if stringName is "E" and i is 0
					stringName = "e"
				
				if noteStrings[stringName]?
					noteStrings[stringName] += someNotes # STRING the notes together HAHAHAHAHAHAHAHA um
				else
					console.log "Your guitar is out of tune. #maybe"
					console.debug AnyBlocks.exec(block)
					throw new Error "Your guitar is out of tune. #maybe"
			
			"{....}"
		
		if noteStrings.B.length > 0
			throw new Error "Alternate tunings are not yet supported."
	
	
	# fallback for blocks that have no string names
	if noteStrings.B.length is 0
		# (minimum of three dashes in each line)
		NamelessBlock = ///
			(([^\n]*-[^\n]*-[^\n]*-[^\n]*)\n){5}
			([^\n]*-[^\n]*-[^\n]*-[^\n]*)*
		///gim
		str.replace NamelessBlock, (block)->
			console.log "block found with no string names:\n#{block}"
			lines = block.split("\n")
			for line, i in lines
				someNotes = line.trim()
				noteStrings["eBGDAE"[i]] += "+" + someNotes # STRING the notes together HAHAHAHAHAHAHAHA um
			
			"{.....}"
	
	# @TODO: alert (more) problems with the tabs
	if noteStrings.B.length is 0
		throw new Error "Tab interpretation failed. (No music blocks found?)"
	
	for s, noteString of noteStrings
		if noteString.length isnt noteStrings.e.length
			alignment_marker = "<< (this text must line up)"
			throw new Error """
				Tab interpretation failed due to misalignment:
				
				#{noteStrings.e} #{alignment_marker}
				#{noteStrings.B} #{alignment_marker}
				#{noteStrings.G} #{alignment_marker}
				#{noteStrings.D} #{alignment_marker}
				#{noteStrings.A} #{alignment_marker}
				#{noteStrings.E} #{alignment_marker}
				
				(Any music blocks found were merged together above.)
			"""
			# @TODO: show individual blocks that were uneven instead of the entire concatenated block
	
	# heuristically address the ambiguity where
	# e.g. --12-- can mean either twelve or one then two
	squishy = not not str.match /[03-9]\d[^\n*]-/
	
	pos = 0
	cont = yes
	notes = []
	while cont
		cont = no
		multi_digit = no
		chord = []
		
		for s, noteString of noteStrings
			ch = noteString[pos]
			ch2 = noteString[pos+1]
			cont = yes if ch?
			multi_digit = yes if ch?.match(/\d/) and ch2?.match(/\d/) unless squishy
		
		for s, noteString of noteStrings
			ch = noteString[pos]
			ch2 = noteString[pos+1]
			if ch?.match(/\d/) or (multi_digit and ch2?.match(/\d/))
				if ch2?.match(/\d/) and not squishy
					chord.push
						f: if ch is "-" then parseInt(ch2) else parseInt(ch + ch2)
						s: tuning.indexOf(s)
				else
					chord.push
						f: parseInt(ch)
						s: tuning.indexOf(s)
		
		if chord.length > 0
			notes.push(chord)
		
		pos++
		pos++ if multi_digit
	
	if notes.length is 0
		# this probably shouldn't be an error
		throw new Error "No notes?!?!?!?!?!?? >:("
	
	# for s, noteString of noteStrings
	# 	console.log s, song.tabs.indexOf(s)
	# 	if song.tabs.indexOf(s) >= 0
	# 		song.tabs[tuning.indexOf(s)] += noteStrings[s]
	# 	else
	# 		console.log "UUHUHHH :/"
	
	return notes


# @TODO: parse and stringify?

if module?
	module.exports = parseTabs
else
	@parseTabs = parseTabs
