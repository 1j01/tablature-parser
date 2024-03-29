# Tablature Parser

A JavaScript tablature parser that parses guitar tabs.

Check out the [tests](test/) for some of the things it can handle.

Try it out in [Guitar](https://github.com/1j01/guitar), just paste in some tabs.


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

## Changelog

For a history of API changes, see [CHANGELOG.md](CHANGELOG.md).

## License

[MIT](LICENSE.txt)

## Development

```bash
npm install
npm test:watch
```
For publishing, edit CHANGELOG.md, adding/updating version numbers in 5 places, plus a date, and then run:
```bash
npm version patch/minor/major
npm publish
```
and push the commit and tag.

## TODO

* Establish and document a decent API
* Parse articulations
* Support alternate tunings
* Support other instruments
* Somehow include the vague timing information sometimes provided by spacing
  (other times notes can be spaced based on the lyrics or not spaced at all)
