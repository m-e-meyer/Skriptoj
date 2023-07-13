/*
Utilities for bash-like command line parsing
*/

since r27369;    // vararg support


record acli_command_parameters {
    boolean[string] flags;
    string[string] options;
    string[int] parameters;
    string[int] errors;
};

boolean has_errors(acli_command_parameters cp)
{
    return (cp.errors.count() > 0);
}

/*
Overload print to print formatted display of acli_command_parameters
*/
void print(acli_command_parameters cp)
{
    print("Flags:");
    foreach o, val in cp.flags
        print(`  {o}: {val}`);
    print("Options:");
    foreach o, val in cp.options
        print(`  {o}: {val}`);
    print("Parameters:");
    foreach o, val in cp.parameters
        print(`  {o}: {val}`);
    if (cp.has_errors()) {
        print("Errors:");
        foreach o, val in cp.errors
            print(`  {o}: {val}`);
    }
}


/*
Parse parameter string into words.  Characters between quotation marks will be in the same word, regardless of spaces.
*/
string[int] acli_parse_into_words(string args)
{
    int SPACE=0; int SQUOTE=1; int DQUOTE=2; int NONSPACE=3;
    string[int] result;
    result[0] = "<script>";
    string arg = "";
    int state=SPACE;
    int i = 0;
    args = args + " ";  // trailing space for clean termination
    while (i < length(args)) {
        string c = substring(args, i, i+1);
        //print(c + " " + to_string(state));
        if (" " < c) { // nonspace
            switch (c) {
            case '\\':
                if (state == SPACE)  state=NONSPACE;
                arg = arg + substring(args, i+1, i+2);
                i = i+1;
                break;
            case '"':
                if (state == DQUOTE)  state=NONSPACE;
                else if (state == SQUOTE)  arg = arg+c; 
                else state = DQUOTE;
                break;
            case "'":
                if (state == SQUOTE)  state=NONSPACE;
                else if (state == DQUOTE)  arg = arg+c; 
                else state = SQUOTE;
                break;
            default:
                if (state == SPACE)  state=NONSPACE;
                arg = arg+c;
                break;
            } 
        } else { // space
            switch (state) {
            case SPACE: break;
            case SQUOTE: arg = arg+" "; break;
            case DQUOTE: arg = arg+" "; break;
            case NONSPACE:
                result[result.count()] = arg;
                arg = "";
                state=SPACE;
                break;
            }
        }
        i = i+1;
    }
    return result;
}


/*
This parses a bash-like command string into an acli_command_parameters object, from which the flags,
options, and parameters can be extracted.
*/
acli_command_parameters acli_parse(string args, string opts)
{
    acli_command_parameters result;
    // Break command into words, obeying quotes
    string[int] words = acli_parse_into_words(args);
    // Create table of options
    string[string] switches;
    int i = 0;
    boolean silent_error_checking = false;
    if (0 < length(opts) && substring(opts, 0, 1) == ":") {
        silent_error_checking = true;
        i = 1;
    }
    while (i < length(opts)) {
        string c = substring(opts, i, i+1);
        if (i+1 < length(opts) && substring(opts, i+1, i+2) == ':') {
            switches[c] = 'string';
            i = i+2;
        } else {
            switches[c] = 'boolean';
            result.flags[c] = false;
            i = i+1;
        }
    } 
    // Process options
    int w = 1;
    int p = 1;
    boolean seeking_opts = true;
    while (w < count(words)) {
        string word = words[w];
        if (seeking_opts && substring(word, 0, 1) == '-') {
            if (word == '--') 
                seeking_opts = false;
            else {
                int i = 1;
                while (i < length(word)) {
                    string c = substring(word, i, i+1);
                    if (switches contains c) {
                        if (switches[c] == 'boolean')
                            result.flags[c] = true;
                        else {
                            if (words contains (w+1)) {
                                result.options[c] = words[w+1];
                                w = w+1;
                            } else {
                                result.errors[result.errors.count()] = `Missing value for flag: {c}`;
                                if (! silent_error_checking) {
                                    return result;
                                }
                            }
                        }
                    } else {
                        result.errors[result.errors.count()] = `Unknown option: {c}`;
                        if (! silent_error_checking) {
                            return result;
                        }
                    }
                    i = i+1;
                }
            }
        } else {
            seeking_opts = false;
            result.parameters[p] = word;
            p = p+1;
        }
        w = w+1;
    }
    
    return result;
}

acli_command_parameters acli_parse(string[int] args, string opts)
{
  return acli_parse(join_strings(args, ' '), opts);
}

acli_command_parameters acli_parse(string args)
{
    return acli_parse(args, "");
}

acli_command_parameters acli_parse(string[int] args)
{
  return acli_parse(join_strings(args, ' '), "");
}

/*
This supports partial naming of choices, so that an entire choice doesn't need to be typed out.
Takes a lookup table, a string-indexed array of int-indexed string arrays.  The keys of the
lookup table represent the expected entries.  The values of the lookup table are int-indexed 
arrays.  Index 0, if present, is an explanation of the choice, good for help displays.  In fact,
if an unexpected prefix is given and print_help is true, then this prints the list of valid
choices and their meanings.  

Returns a 0-based int-indexed array of the available options matching the given option.  Ideally
this array should have only one element.
*/
string[int] acli_lookup(string[string][int] lookup_tbl, string prefix, boolean print_help)
{
    prefix = to_lower_case(prefix);
    string[int] result;
    foreach c in lookup_tbl {
        if (prefix == "" || index_of(to_lower_case(c), prefix) == 0) {
            result[count(result)] = c;
        }
    }
    if (count(result) > 1 && print_help) {
        if (prefix == "") {
            print("Lookup string not supplied.  Available entries:", "red");
        } else {
            print(`More than one command matches {prefix}.`, "red");
        }
        foreach n, c in result {
            print(`{c}: {lookup_tbl[c][0]}`, "red");
        }
    } else if (count(result) == 0) {
        print(`Unrecognized option {prefix}.  Available options:`);
        foreach c in lookup_tbl {
            print(`{c}: {lookup_tbl[c][0]}`);
        }
    }
    return result;
}

/*
Split a parameter string into a word (without spaces) and the rest of the string, if any
*/
string[int] get_first_word(string parmstring)
{
    string[int] result;
    matcher m = create_matcher(" *([^ ]*) *(.*)$", parmstring);
    if (find(m)) {
        result[0] = group(m, 1);
        result[1] = group(m, 2);
    } else {
        result[0] = parmstring;
        result[1] = "";
    }
    return result;
}

/*
Make a string out of a list of string
///////////////////////////////////////////////////////////////

/*
Main function just for testing
*/
void main(string... args)
{
    acli_command_parameters acp = acli_parse(args, "abcx:y:z:");
    print("Valid flags (no args): abc; valid options (args): xyz", 'blue');
    print(acp);
    
    string[string][int] choice_tbl = {
        "yes": { 0: "Do it" },
        "maybe": { 0: "Do it, or don't" },
        "misc": { 0: "Huh?" },
        "no": { 0: "Don't do it" } };
    string[int] found = acli_lookup(choice_tbl, acp.parameters[1], true);
    if (found.count() == 1) {
        print(`The string found was {found[0]}.`);
    }
}
