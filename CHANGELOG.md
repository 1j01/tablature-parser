
# Changelog

All notable changes to this project will be documented in this file.

## [Unreleased]
<details>
	<summary>
		Changes in master that are not yet released.
		Click to see more.
	</summary>

Nothing yet.

</details>

## [0.10.1] - 2023-04-08

- Updated to CoffeeScript 2. No functional changes.

## [0.10.0] - 2023-04-08

- First release published to npm.

The API is super simple, so I'll include it here:

#### `Tablature.parse(tablature)`

Attempts to parse the given tablature.
Throws an error if no music blocks are found,
or if there are other problems with the input.
Returns an array of arrays of notes.
(The arrays of notes allow chords.)
Individual notes are objects with properties `{s, f}`.
`s` is the string index and `f` is the fret index (both 0-based).

#### `Tablature.stringify(notes)`

Given a note structure described above,
returns a normalized single row of tablature as a string.


[Unreleased]: https://github.com/1j01/tablature-parser/compare/v0.10.1...HEAD
[0.10.1]: https://github.com/1j01/tablature-parser/compare/v0.10.0...v0.10.1
[0.10.0]: https://github.com/1j01/tablature-parser/releases/tag/v0.10.0
