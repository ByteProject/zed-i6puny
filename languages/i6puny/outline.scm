; outline.scm
; Inform 6 x PunyInform, syntax highlighting for the Zed editor.
; Copyright (c) 2026, Stefan Vogt.
;
; The symbols Zed's breadcrumbs and symbol search navigate: routines, objects
; and classes, and the named declarations. Embedded routines are deliberately
; absent, since a property's routine belongs to its object, not to the file.

(routine
  "[" @context
  name: (identifier) @name) @item

(object_declaration
  keyword: (object_keyword) @context
  name: (identifier) @name) @item

(value_declaration
  keyword: (value_keyword) @context
  name: (identifier) @name) @item

(array_declaration
  keyword: (array_keyword) @context
  name: (identifier) @name) @item

(verb_declaration
  keyword: (verb_keyword) @context
  (dict_word) @name) @item
