; highlights.scm
; Inform 6 x PunyInform, syntax highlighting for the Zed editor.
; Copyright (c) 2026, Stefan Vogt.
; https://github.com/ByteProject/zed-i6puny
;
; ORDER MATTERS: in Zed the LATER pattern wins. So the generic identifier SETS
; come first, and the structural, position-aware captures come last and
; override them wherever context knows better than spelling does. Two
; consequences worth stating, because both are fixed bugs:
;
;   1. A word set can never beat a declaration head. `Object noun ...` colours
;      `noun` as a type because the object_declaration capture is further down
;      this file than the library-variable set.
;   2. Single-quoted forms are ambiguous in Inform 6 and are resolved in three
;      passes at the bottom: dictionary word by default, character code when
;      the text is a single character (102 of them in the PunyInform corpus
;      against 7 dictionary uses), then back to dictionary word inside a Verb
;      or grammar line, where position settles it.
;
; The vocabulary is two libraries at once. Shared concepts share a colour: an
; attribute is an attribute whichever library defines it. The one deliberate
; split is PunyInform's CONFIGURATION constants, the compile-time switches you
; set before Include "puny.h", which get @constant.builtin because they are a
; different kind of thing from a value you read.

; ==========================================================================
; Generic word sets
; ==========================================================================

; ---- Inform 6 statements and flow ----------------------------------------

((identifier) @keyword
  (#any-of? @keyword
    "box" "break" "continue" "do" "else" "font" "for" "give" "if"
    "inversion" "jump" "move" "new_line" "objectloop" "quit" "read"
    "remove" "restore" "return" "rfalse" "rtrue" "save" "spaces" "string"
    "style" "switch" "until" "while" "default" "to" "off"
    ; the style and font arguments
    "roman" "bold" "underline" "fixed"
    ; expression keywords
    "in" "notin" "ofclass" "or" "provides"))

; with / has / hasnt / private, the object body sections.
(section) @keyword

; ---- language constants ---------------------------------------------------

((identifier) @boolean (#any-of? @boolean "true" "false"))

((identifier) @constant.builtin (#any-of? @constant.builtin "nothing" "NULL"))

; ---- attributes (DM4 and PunyInform) --------------------------------------

((identifier) @attribute
  (#any-of? @attribute
    "absent" "animate" "clothing" "concealed" "container" "door" "edible"
    "enterable" "female" "general" "light" "lockable" "locked" "male"
    "moved" "neuter" "on" "open" "openable" "pluralname" "proper"
    "reactive" "scenery" "scored" "static" "supporter" "switchable"
    "talkable" "transparent" "visited" "workflag" "worn"))

; ---- properties (DM4 and PunyInform, plus the shipped extensions) ---------

((identifier) @property
  (#any-of? @property
    "add_to_scope" "after" "article" "articles" "before" "before_implicit"
    "cant_go" "capacity" "compass_look" "d_to" "daemon" "describe"
    "description" "door_dir" "door_to" "e_to" "each_turn" "ext_initialise"
    "ext_messages" "found_in" "grammar" "in_to" "initial"
    "inside_description" "invent" "life" "list_together" "n_to" "name"
    "ne_to" "nw_to" "orders" "out_to" "parse_name" "plural" "react_after"
    "react_before" "s_to" "se_to" "short_name" "short_name_indef" "sw_to"
    "time_left" "time_out" "timer_order" "u_to" "w_to" "when_closed"
    "when_off" "when_on" "when_open" "with_key"
    ; ext_cheap_scenery and ext_talk_menu
    "cheap_scenery" "talk_array"))

; ---- library routines (DM4 and PunyInform) --------------------------------

((identifier) @function
  (#any-of? @function
    "Achieved" "AddToScope" "AfterRoutines" "AllowPushDir" "Banner" "call"
    "Cap" "Centre" "ChangeFgColour" "ChangePlayer" "child" "children"
    "ChooseObjectsFinal_Discard" "ChooseObjectsFinal_Pick" "ClearScreen"
    "CommonAncestor" "copy" "create" "DecimalNumber" "destroy"
    "DictionaryLookup" "DoorDir" "DoorTo" "DrawStatusLine" "FastSpaces"
    "GetGNAOfObject" "glk" "HasLightSource" "ImplicitDisrobeIfWorn"
    "ImplicitGrabIfNotHeld" "IndirectlyContains" "IsARoutine" "IsAString"
    "IsSeeThrough" "KeyCharPrimitive" "KeyDelay" "LanguageNumber" "Length"
    "Locale" "LoopOverScope" "LowerCase" "LTI_Insert" "MainWindow"
    "metaclass" "MoveCursor" "MoveFloatingObjects" "NextEntry" "NextWord"
    "NextWordStopped" "NounDomain" "NumberWord" "NumberWords"
    "ObjectCapacity" "ObjectIsUntouchable" "OffersLight"
    "OzmooColoursAvailable" "parent" "ParseToken" "PlaceInScope" "PlayerTo"
    "print_to_array" "PrintAnything" "PrintAnyToArray" "PrintCapitalised"
    "PrintContents" "PrintContentsFromR" "PrintMsg" "PrintOrRun"
    "PrintOrRunVal" "PrintToBuffer" "PronounNotice" "PronounValue" "random"
    "recreate" "remaining" "RunRoutines" "ScopeWithin" "ScreenHeight"
    "ScreenWidth" "SetColour" "SetPronoun" "SetTime" "sibling" "StartDaemon"
    "StartTimer" "StatusLineHeight" "StopDaemon" "StopTimer" "TestScope"
    "TryNumber" "UnsignedCompare" "UpperCase" "WordAddress" "WordInProperty"
    "WordLength" "WordValue" "WriteListFrom" "YesOrNo"))

; The entry points and hooks a game DEFINES. Listing them as well as capturing
; them at their declaration means a reference lights up too, which is what you
; want in `#Ifdef SceneryReply;`.
((identifier) @function
  (#any-of? @function
    "AfterLife" "AfterPrompt" "Amusing" "BeforeParsing" "ChooseObjects"
    "ChooseObjectsFinal" "DarkToDark" "DeathMessage" "DebugParseNameObject"
    "DisallowTakeAnimate" "GamePostRoutine" "GamePreRoutine" "InScope"
    "Initialise" "IsARoom" "LibraryMessages" "LookRoutine" "NewRoom"
    "ParseNoun" "ParseNumber" "PrintRank" "PrintTaskName" "PrintVerb"
    "SceneryReply" "TimePasses" "UnknownVerb"))

; The printing rules, used as `print (OnOff) pump;`.
((identifier) @function
  (#any-of? @function
    "CObjIs" "CTheyreorIts" "CTheyreorThats" "IsOrAre" "ItorThem" "ObjIs"
    "OnOff" "SingularS" "ThatorThose"))

; The shipped PunyInform extensions: the routines an author calls.
((identifier) @function
  (#any-of? @function
    ; ext_flags
    "SetFlag" "ClearFlag" "FlagIsSet" "FlagIsClear" "AnyFlagIsSet"
    "AnyFlagIsClear"
    ; ext_menu, ext_quote_box
    "DoMenu" "QuoteBox"
    ; ext_talk_menu
    "RunTalk" "ActivateTopic" "InactivateTopic" "ReActivateTopic"
    "ReInactivateTopic" "GetTopicStatus" "TMPrintLine"
    ; ext_cheap_scenery
    "CSHasAdjective" "CSHasNoun" "CSHasWord" "CSPerformAction"))

; ---- library variables and objects (DM4 and PunyInform) -------------------

((identifier) @variable.special
  (#any-of? @variable.special
    "action" "action_to_be" "actor" "buffer" "c_style" "caps_mode" "clr_bg"
    "clr_fg" "clr_fginput" "clr_fgstatus" "clr_on" "clr_talk_menu" "compass"
    "consult_from" "consult_word" "consult_words" "cs_match_id"
    "current_talker" "d_obj" "deadflag" "e_obj" "etype" "gg_event"
    "gg_mainwin" "gg_statuswin" "in_obj" "indef_mode" "inp1" "inp2"
    "input_action" "input_direction" "input_noun" "input_second"
    "inventory_stage" "inventory_style" "item_name" "item_width"
    "keep_silent" "lm_n" "lm_o" "location" "lookmode" "menu_item"
    "menu_nesting" "meta" "multiple_object" "n_obj" "ne_obj"
    "no_implicit_actions" "normal_directions_enabled" "notify_mode" "noun"
    "num_words" "nw_obj" "out_obj" "parse" "parsed_number" "parser_action"
    "parser_inflection" "parser_one" "parser_two" "player" "real_location"
    "receive_action" "run_after_routines_arg_1" "run_after_routines_msg"
    "s_obj" "scope_modified" "scope_reason" "scope_stage" "score" "se_obj"
    "second" "selected_direction" "self" "ship_directions_enabled"
    "standard_interpreter" "sw_obj" "sys_statusline_flag" "take_flag"
    "talk_menu_multi_mode" "talk_menu_talking" "task_done" "task_scores"
    "the_time" "thedark" "turns" "u_obj" "update_moved" "vague_word"
    "verb_word" "verb_wordnum" "w_obj" "waittime_waiting" "wn"
    ; the library objects
    "Directions" "selfobj"))

; ---- library constants (values you read) ----------------------------------

((identifier) @constant
  (#any-of? @constant
    ; library identity and version
    "LIBRARY_ENGLISH" "LIBRARY_GRAMMAR" "LIBRARY_PARSER" "LIBRARY_VERBLIB"
    "LIBRARY_VERSION" "DIRECTION_COUNT"
    ; list-writing style bits
    "ALWAYS_BIT" "CONCEAL_BIT" "DEFART_BIT" "ENGLISH_BIT" "FULLINV_BIT"
    "INDENT_BIT" "ISARE_BIT" "NEWLINE_BIT" "NOARTICLE_BIT" "PARTINV_BIT"
    "RECURSE_BIT" "TERSE_BIT" "WORKFLAG_BIT"
    ; general parsing routine results
    "GPR_FAIL" "GPR_MULTIPLE" "GPR_NUMBER" "GPR_PREPOSITION" "GPR_REPARSE"
    ; grammar token types
    "CREATURE_TOKEN" "HELD_TOKEN" "MULTI_TOKEN" "MULTIEXCEPT_TOKEN"
    "MULTIHELD_TOKEN" "MULTIINSIDE_TOKEN" "NUMBER_TOKEN" "NOUN_TOKEN"
    "ELEMENTARY_TT" "SCOPE_TT" "REPARSE_CODE"
    ; scope reasons
    "EACHTURN_REASON" "EACH_TURN_REASON" "LOOPOVERSCOPE_REASON"
    "PARSING_REASON" "REACT_AFTER_REASON" "REACT_BEFORE_REASON"
    "TALKING_REASON" "TESTSCOPE_REASON"
    ; parser errors
    "ANIMA_PE" "ASKSCOPE_PE" "CANTSEE_PE" "EXCEPT_PE" "ITGONE_PE"
    "JUNKAFTER_PE" "MMULTI_PE" "MULTI_PE" "NOTHELD_PE" "NOTHING_PE"
    "NUMBER_PE" "SCENERY_PE" "STUCK_PE" "TOOFEW_PE" "TOOLIT_PE" "UPTO_PE"
    "VAGUE_PE" "VERB_PE"
    ; windows, virtual machine, Glulx
    "WIN_ALL" "WIN_MAIN" "WIN_STATUS" "TARGET_GLULX" "TARGET_ZCODE"
    "WORDSIZE" "FLOAT_INFINITY" "FLOAT_NINFINITY" "FLOAT_NAN"
    "GG_MAINWIN_ROCK" "GG_QUOTEWIN_ROCK" "GG_STATUSWIN_ROCK"))

; The colour constants, including PunyInform's Ozmoo palette.
((identifier) @constant
  (#match? @constant "^CLR_[A-Z_]+$"))

; PunyInform runtime-error levels and the talk-menu and cheap-scenery values.
((identifier) @constant
  (#match? @constant "^(RTE_|TM_|CS_|FL_|QB_|PUNYINFORM_)[A-Z0-9_]+$"))

; ---- actions ---------------------------------------------------------------

; Group 1, the metaverbs (no before or after routines).
((identifier) @constant
  (#any-of? @constant
    "Again" "FullScore" "LMode1" "LMode2" "LMode3" "LookModeLong"
    "LookModeNormal" "LookModeShort" "Miscellany" "NotifyOff" "NotifyOn"
    "Objects" "Oops" "OopsCorrection" "Places" "Prompt" "Pronouns" "Quit"
    "Restart" "Restore" "Save" "Score" "ScriptOff" "ScriptOn" "TheSame"
    "Verify" "Version" "CommandsOff" "CommandsOn" "CommandsRead"
    ; the DEBUG verbs
    "ActionsOff" "ActionsOn" "Debug" "Forest" "GoNear" "Goto" "Purloin"
    "RandomSeed" "Rooms" "RoutinesOff" "RoutinesOn" "Scope" "TimersOff"
    "TimersOn" "Tree"))

; Group 2, the actions that change the world (before and after both run).
((identifier) @constant
  (#any-of? @constant
    "Close" "Disrobe" "Drop" "Eat" "Empty" "EmptyT" "Enter" "Examine"
    "Exit" "GetOff" "Go" "GoIn" "Insert" "Inv" "InvTall" "InvWide" "Lock"
    "Look" "Open" "PutOn" "Remove" "Search" "SwitchOff" "SwitchOn" "Take"
    "Transfer" "Unlock" "Wait" "Wear"))

; Group 3, the actions that print a message (before only).
((identifier) @constant
  (#any-of? @constant
    "Answer" "Ask" "AskFor" "AskTo" "Attack" "Blow" "Burn" "Buy" "Climb"
    "Consult" "Cut" "Dig" "Drink" "Fill" "Give" "Jump" "JumpIn" "JumpOn"
    "JumpOver" "Kiss" "Listen" "LookUnder" "Mild" "No" "Order" "Pray"
    "Pull" "Push" "PushDir" "Rub" "Set" "SetTo" "Shout" "ShoutAt" "Show"
    "Sing" "Sleep" "Smell" "Sorry" "Squeeze" "Strong" "Swim" "Swing"
    "Taste" "Tell" "Think" "ThrowAt" "Tie" "Touch" "Turn" "VagueGo" "Wake"
    "WakeOther" "Wave" "WaveHands" "Yes"))

; Fake actions: no grammar line and no action routine, only a message.
((identifier) @constant
  (#any-of? @constant
    "Going" "LetGo" "NotUnderstood" "PluralFound" "Receive" "ThrownAt"))

; NOTE: there is deliberately no word set for the grammar line tokens (noun,
; held, multi, creature, topic, scope, special). They are recognised by
; POSITION further down, in `(grammar_line (identifier) @type)`. A word set
; would be actively wrong: `noun` and `second` are library variables
; everywhere except inside a grammar line, and a set cannot tell the
; difference, so `print (a) noun` would colour noun as a grammar token.

; ---- the built-in classes --------------------------------------------------

((identifier) @type.builtin
  (#any-of? @type.builtin
    "Class" "CompassDirection" "Object" "Routine" "String"))

; ==========================================================================
; Plain tokens
; ==========================================================================

(comment) @comment

; !% is the ICL switch comment: it sets compiler options from the source file,
; so it is a directive wearing a comment's clothes.
(switch_comment) @preproc

(number) @number
(operator) @operator
(semicolon) @punctuation.delimiter

((punctuation) @punctuation.bracket
  (#any-of? @punctuation.bracket "(" ")" "{" "}" "]"))

((punctuation) @punctuation.delimiter
  (#any-of? @punctuation.delimiter "," ":"))

; @set_cursor, @jz, @"S2:14": the assembly layer.
(assembly) @function

; ##Take, the action constant.
(action_constant) @constant

; ==========================================================================
; Structural captures: position beats spelling
; ==========================================================================

; ---- routines --------------------------------------------------------------

(routine name: (identifier) @function)
(routine local: (identifier) @variable.parameter)
(embedded_routine local: (identifier) @variable.parameter)
(property_routine property: (identifier) @property)

; ---- objects and classes ---------------------------------------------------

(object_keyword) @keyword
(object_declaration arrows: (arrows) @punctuation.special)
(object_declaration name: (identifier) @type)
(object_declaration parent: (identifier) @variable)

; ---- arrays ----------------------------------------------------------------

(array_keyword) @keyword
(storage) @keyword
(array_declaration name: (identifier) @variable)

; Every declaration modifier: static, additive, long, meta, only, first,
; last, replace, reverse, and the Message and Statusline arguments.
(modifier) @keyword

; ---- Constant, Global, Attribute, Property, Default, Stub, Fake_action -----
;
; The declared name takes the colour of the thing being declared, which is the
; only place an author's OWN attribute or property can be recognised.

(value_keyword) @keyword
(value_declaration name: (identifier) @variable)

((value_declaration
   keyword: (value_keyword) @_kw
   name: (identifier) @constant)
  (#match? @_kw "(?i)^(constant|default|stub|fake_action|lowstring)$"))

((value_declaration
   keyword: (value_keyword) @_kw
   name: (identifier) @attribute)
  (#match? @_kw "(?i)^attribute$"))

((value_declaration
   keyword: (value_keyword) @_kw
   name: (identifier) @property)
  (#match? @_kw "(?i)^property$"))

; ---- verbs and grammar lines -----------------------------------------------

(verb_keyword) @keyword

(grammar_line "*" @punctuation.special)
(grammar_line "->" @punctuation.special)
(grammar_line (identifier) @type)
(grammar_line action: (identifier) @constant)

; ---- includes and directives -----------------------------------------------

(include_keyword) @keyword
(include_directive target: (identifier) @type)

(directive "#" @keyword)
(directive_keyword) @keyword

; Conditional compilation recedes: it is scaffolding, not story. The name is
; deliberately NOT captured here, so the constant it refers to keeps whichever
; colour its set gave it.
(conditional "#" @preproc)
(conditional_keyword) @preproc

; ---- print statements and print rules --------------------------------------
;
; Recognising a print rule by POSITION rather than by a word list is what makes
; a custom rule such as (OnOff) pump colour correctly, while a bare (a) in
; `if (a)` is left alone.

(print_keyword) @keyword
(print_rule "(" @punctuation.special)
(print_rule ")" @punctuation.special)
(print_rule name: (identifier) @function)

; ---- action invocations ----------------------------------------------------

(action_form "<<" @punctuation.special)
(action_form ">>" @punctuation.special)
(action_form "<" @punctuation.special)
(action_form ">" @punctuation.special)
(action_form . (identifier) @constant)

; ---- PunyInform configuration constants -----------------------------------
;
; The compile-time switches a game sets before including puny.h. These come
; after the structural captures, so a switch is recognised at the line where
; the author SETS it (`Constant OPTIONAL_SCORED;`) and not only where it is
; read. The families are matched by prefix rather than by a list of some 200
; names, which also means a game's own MSG_ override is recognised.

((identifier) @constant.builtin
  (#match? @constant.builtin
    "^(OPTIONAL_|MSG_|SKIP_MSG_|DEBUG_|STATUSLINE_|EXT_)[A-Z0-9_]*$"))

((identifier) @constant.builtin
  (#any-of? @constant.builtin
    "AMUSING_PROVIDED" "CUSTOM_ABBREVIATIONS" "CUSTOM_PLAYER_OBJECT"
    "DEATH_MENTION_UNDO" "DEBUG" "DEFAULT_CAPACITY" "DIALECT_US" "Headline"
    "INITIAL_LOCATION_VALUE" "MAX_CARRIED" "MAX_FLOATING_OBJECTS"
    "MAX_SCOPE" "MAX_SCORE" "MAX_TIMERS" "NO_MOVES" "NO_PLACES" "NO_SCORE"
    "NUMBER_TASKS" "OBJECT_SCORE" "ROOM_SCORE" "RUNTIME_ERRORS"
    "SACK_OBJECT" "STRICT_MODE" "Story" "TASKS_PROVIDED"
    ; the shipped extensions
    "FLAG_COUNT" "MAX_WAIT_MINUTES" "MAX_WAIT_MOVES" "QUOTE_MAX_LENGTH"
    "QUOTE_INDENT_STRING" "GOTOSUB_BUFFER_SIZE" "GRAMMAR_META_FLAG"))

; ==========================================================================
; Strings last, so nothing bleeds into them
; ==========================================================================

(string) @string
(escape_sequence) @string.escape

; @00 to @31 print a string variable's contents from inside the string.
(print_variable) @variable.special

; 'brass' is a word in the dictionary.
(dict_word) @string.special.symbol
(plural_marker) @string.escape

; 'x' is the character code 120. Same syntax, different meaning, and only the
; text length tells them apart here.
((dict_word) @number (#match? @number "^'[^']'$"))
((dict_word) @number (#match? @number "^'@[^']*'$"))

; Except inside a Verb or a grammar line, where a single letter is the standard
; abbreviation for a verb and is a dictionary word after all.
(verb_declaration (dict_word) @string.special.symbol)
(grammar_line (dict_word) @string.special.symbol)
