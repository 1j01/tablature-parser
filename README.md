# Tablature Parser

A JavaScript tablature parser that parses guitar tabs.

Check out the [tests](test/) for some of the things it can handle.


## 0.x API

Note: API will change before `1.0`.
It will likely include the tuning of the song in addition to the notes.
It might use some classes like `Note` and `Song`
(or `TabbedNote` and `TabbedSong`).


### `Tablature.parse(tablature)`

Attempts to parse the given tablature.
Throws an error if no music blocks are found,
or if there are other problems with the input.
Returns an array of arrays of notes.
(The arrays of notes allow chords.)
Individual notes are objects with properties `{s, f}`.
`s` is the string index and `f` is the fret index (both 0-based).


### `Tablature.stringify(notes)`

Given a note structure described above,
returns a normalized single row of tablature as a string.


## TODO

* Establish and document a decent API
* Compile the CoffeeScript in a build step
* License and publish to npm
* Parse articulations
* Support alternate tunings
* Support other instruments
* Somehow include the vague timing information provided by spacing
