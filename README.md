# Inform 6 x PunyInform

Syntax highlighting for [Inform 6](https://www.inform-fiction.org/), the
classic interactive-fiction programming language, with first-class
support for the [PunyInform](https://github.com/johanberntsson/PunyInform)
library.

Inform 6 is the language, documented in the *Inform Designer's Manual,
4th edition* (DM4) by Graham Nelson, and shipped with the Inform 6
Standard Library. [PunyInform](https://github.com/johanberntsson/PunyInform),
by Fredrik Ramsberg and Johan Berntsson, is an independent library for the
same language and the same compiler: its own stdlib and its own parser,
written from scratch to be small and fast, and kept deliberately familiar
to Inform 6 authors rather than derived from the Standard Library. It is
aimed at 8-bit machines such as the Commodore 64.

This extension aims to cover the language as thoroughly as DM4 documents
it, highlights the Standard Library's vocabulary, and adds first-class
support for PunyInform's own author-facing surface, down to its shipped
extensions.

## What it highlights

**The language.** Directives (case-insensitive, as Inform 6 allows: the
PunyInform library itself writes `Endif`, `endif` and `EndIf`), object
declarations with the arrow tree and attribute negation, routine heads
with their locals, statements and flow control, `<<Action noun>>` and
`<Action>`, `##Action` constants, `@opcode` assembly with its branch
labels, and conditional compilation with or without the leading `#`.

**Strings, told apart.** A text string `"..."` and a dictionary word
`'brass'` get distinct colours, because confusing the two is the classic
Inform 6 mistake. String escapes (`@{1F}`, `@@64`, `~`, `^`), the `@00`
to `@31` printing variables, and the `//p` plural marker are picked out
inside them. A single-character form such as `'x'` is shown as the
character code it is, except inside a `Verb` or a grammar line, where it
is the standard abbreviation for a verb and is a dictionary word.

**Print rules.** `print (the) obj`, `(a)`, `(name)`, `(address)`,
`(char)`, `(number)` and a custom rule such as `(OnOff) pump` are all
recognised, because the print statement is parsed structurally rather
than matched against a word list. A bare `(a)` in `if (a)` is left alone.

**Two libraries.** The Inform 6 Standard Library and PunyInform's
vocabulary: attributes, properties, library routines, globals, actions
and library constants. Shared concepts share a colour, because an
attribute is an attribute whichever library defines it. PunyInform's
*configuration* constants get their own colour, since the `OPTIONAL_*`,
`MSG_*` and `SKIP_MSG_*` families and their friends are compile-time
switches you set before `Include "puny.h"`, not values you read.

**The shipped extensions.** `ext_cheap_scenery` (the `cheap_scenery`
property, the `CS_*` constants and the `SceneryReply` hook),
`ext_talk_menu`, `ext_flags`, `ext_menu`, `ext_quote_box` and
`ext_waittime`.

**An outline** of routines, objects, classes, constants, globals, arrays
and verbs, for breadcrumbs and symbol search.

## File types

`.inf` is claimed automatically.

`.h` is not, and deliberately so. Inform 6 headers use `.h`, but so does
C, and Zed cannot make that conditional: a `first_line_pattern` is only
consulted when no language has matched the file by suffix, so it cannot
filter a suffix claim. Claiming `.h` outright would fight C's built-in
claim on a registration-order tiebreak and take over every C header on
your machine when it won.

Opt in per project instead. In your game's `.zed/settings.json`:

```json
{
  "file_types": {
    "Inform 6 x PunyInform": ["*.h"]
  }
}
```

A user-configured file type wins over a built-in claim, deterministically,
so this works while leaving your C projects alone. Use the same snippet in
your global Zed settings if you want it everywhere.

## Installation

Install **Inform 6 x PunyInform** from Zed's extension registry
(`zed: extensions`).

## Development

The Tree-sitter grammar lives at
[ByteProject/tree-sitter-i6puny](https://github.com/ByteProject/tree-sitter-i6puny)
and is pinned by commit in `extension.toml`. It produces zero error nodes
across the entire PunyInform repository, 85 files, which is its done-test.

To work on the extension locally, clone this repository, run
`zed: install dev extension` and select the clone. Zed fetches the grammar
from the pinned revision and compiles it. After changing a query, run
`zed: rebuild dev extension`.

Changing the GRAMMAR needs a commit, because Zed resolves the grammar
through git and there is no local-path escape hatch: `extension.toml` must
name a repository and a revision. Either commit and push the grammar and
bump the `rev` here, or use the `zed_dev.py` helper, which commits the
grammar to a throwaway repository under `build/` and writes a dev copy of
this extension pointing at it.

## Licence

MIT. See LICENSE.
