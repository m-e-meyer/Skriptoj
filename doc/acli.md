# acli
KoLmafia utility library for processing command parameters similarly to bash

### How to use acli_parse()
Write your main() method with a single string argument.  For example:

`void main(string args)`

Use acli_parse to parse the command arguments passed in that single string.  For example:

`acli_command_parameters acp = acli_parse(args, "fgo:p:");`

`acli_parse` processes the given string, first breaking it into "words" separated by spaces (but strings wrapped in 'single-quotes' and "double-quotes" are never broken).  Then, starting from the left, it looks for flags and options.  Flags are strings like `-x` that represent boolean values.  If a flag is present, its value is `true`, otherwise it is `false`.  Options are strings like `-x` followed by another string that represents the value of the option.  Which letters are flags and options are specified in the second argument to acli_parse.  If a letter is followed by a `:`, that letter represents an option, otherwise it is a flag.  So, in the example above, `f` and `g` are flags and `o` and `p` are options.

If `acli_parse()` encounters a string that it neither a flag nor an option, the string and all subsequent strings are each treated as parameters.

`acli_parse()` returns an `acli_command_parameters` record.  This record has four array fields:
* `boolean[string] flags` holds the boolean values of the supplied flags
* `string[string] options` holds the string values of the supplied options
* `string[int] parameters` holds the string values of the supplied parameters, the first being index 1
* `string[int] errors` holds the error messages that were generated during parsing (ideally, none)

`has_errors()` is another available function.  It just tells whether the errors field of the given acli_command_parameters object is nonempty.

Let's say the script was called with arguments `-f -o 'a choice' param1 "It's a parameter"`, and has the call to `acli_parse()` above.  One would get the following values from the record:
* `acp.flags['f']` = `true`
* `acp.flags['g']` = `false`
* `acp.options['o']` = `"a choice"`
* `acp.options['p']` = `""`
* `acp.parameters[1]` = `"param1"`
* `acp.parameters[1]` = `"It's a parameter"`
* `acp.has_errors()` = `false`

### which_option()

Another feature of bash that I like is being able to type a few characters of a filename or command and hit Tab to finish it.  Mafia's gCLI doesn't have that, so I wrote the next best thing, to look up entries in a table by supplying only the prefix of a key:

`string[int] which_option(string[string][int] opt_tbl, string opt, boolean print_help)`

It takes the following arguments:
* `string[string][int] opt_tbl` is a lookup map.  The first element is a string which is the full name of an option.  The second element is an integer index of a string pertaining to the option.  The index 0 always maps to a help string, used when printing out help information.  The other indexes are optional and may be used however the user wishes.
* `string opt` is the string to look up in the map.
* `boolean print_help` dictates whether to print help information listing the expected options if more than one match is found.  Help information is always printed if no match is found.

`which_option()` returns a map of possible matches in the lookup map for the given option.  The returned map keys are 0, 1, 2, _etc_.  A lookup map key is a match if the given string is a prefix (case-insensitive) of the key.  Ideally, the returned map should have only one element.

For example, let's assume the lookup map is:

    string[string][int] lookup_table = { 
      "create": { 0: "Make a new thing", ... },
      "change": { 0: "Change the thing", ... },
      "delete": { 0: "Get rid of the thing", ... } };
  
Then `which_option(lookup_table, "d", false)` would return `{ 0: "delete" }`, and the scriptr can do whatever is appropriate in response to identifying the `"delete"` choice.  `which_option(lookup_table, "cr", false)` would return `{ 0: "create" }`.  On the other hand, `which_option(lookup_table, "c", false)` would return `{ 0: "change", 1: "create" }`, and the script should complain about not getting a unique choice.  `which_option(lookup_table, "c", true)` would in addition print out help information like so:

    More than one option matches c.
    change: Change the thing
    create: Make a new thing

`which_option(lookup_table, "f", false)` would return an empty map and print out help information listing all the available choices.

I use this a lot in my scripts, mainly in two scripts I have: `f`, which collects a lot of little tasks, and `d`, which collects a lot of little queries.  (In Esperanto, "to do" is "fari", and "to ask" is "demandi".)  If the first argument to `f` is `buffbot`, meaning I want a buff from a buffbot, then the second argument represents what kind of buff to get, like `ode` or `plenty`.  Using `which_option()`, all I have to type to the gCLI to get an Ode to Booze buff is

`f bu o`

### get_first_word()

Scripts like `f` and `d` are really kind of gateways to other scripts.  I would like the first word not to be treated as a parameter by acli_parse(), instead be skipped so acli_parse() starts processing with the second word.  For this I use 

`string[int] get_first_word(string parmstring)`

This just breaks the parameter string into two pieces, the first word and the rest of the string.  For example, `get_first_word("task -o opt param")` would return `{ 0: "task", 1: "-o opt param" }`.
