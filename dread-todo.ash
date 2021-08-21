/*
What's to do in Dreadsylvania?
*/

since r19904;    // template string support

import "acli.ash"


string trim(string s)
{
    int i = 0;
    int e = length(s) - 1;
    while ((i <= e) && substring(s, i, i+1) <= " ")
        i = i+1;
    while ((e > i) && substring(s, e, e+1) <= " ")
        e = e-1;
    if (e <= i)
        return "";
    else
        return substring(s, i, e+1);
}

string[string][string][string][int] choice_order = {
    "1Forest": {
        "1cabin": {
            "1kitchen": { 1:"spice rack", 2:"flour mill", 3:"disposal" },
            "2basement" : { 1:"newspapers", 2:"diary", 3:"lockbox", 4:"banana" },
            "3attic" : { 1:"music box", 2:"wolfsbane", 3:"rafters", 4:"photo albums" }
        },
        "2tree" : { 
            "1climb" : { 1:"stomp", 2:"kick", 3:"shiny thing" },
            "2fire tower" : { 1:"siren", 2:"footlocker", 3:"weights" },
            "3root" : { 1:"look up", 2:"look down", 3:"hole" },
        },
        "3burrows" : { 
            "1heat" : { 1:"pull cork", 2:"play", 3:"melt" },
            "2cold" : { 1:"read", 2:"listen", 3:"drink" },
            "3smelly" : { 1:"smash", 2:"dig" },
        }
    },
    "2Village": {
        "1square" : { 
            "1schoolhouse" : { 1:"erasers", 2:"desk", 3:"carvings" },
            "2blacksmith" : { 1:"furnace", 2:"till", 3:"anvil" },
            "3gallows" : { 1:"paint noose", 2:"trap door", 3:"stand around", 4:"lever" },
        },
        "2skid row" : { 
            "1sewers" : { 1:"unclog", 2:"slosh" },
            "2tenements" : { 1:"rats", 2:"paint", 3:"bricks" },
            "3shack" : { 1:"shelves", 2:"key", 3:"polish", 4:"assemble", 5:"boxes" },
        },
        "3estate" : { 
            "1plot" : { 1:"gates", 2:"graves", 3:"tombstones" },
            "2quarters" : { 1:"ovens", 2:"pie", 3:"cabinets" },
            "3suite" : { 1:"whistle", 2:"nightstand", 3:"loom" },
        }
    },
    "3Castle": {
        "1tower" : { 
            "1laboratory" : { 1:"lamp", 2:"brains", 3:"repair machine", 4:"use machine", 5:"still" },
            "2books" : { 1:"incantations", 2:"secrets", 3:"jewelry" },
            "3bedroom" : { 1:"parrot", 2:"dresser", 3:"magic fingers" },
        },
        "2hall" : { 
            "1ballroom" : { 1:"organ", 2:"trip" },
            "2kitchen" : { 1:"freezer", 2:"hang out" },
            "3dining room" : { 1:"roast", 2:"dishes", 3:"levitate" },
        },
        "3dungeons" : { 
            "1cell block" : { 1:"flush", 2:"pushups", 3:"nap" },
            "2boiler room" : { 1:"steam", 2:"incinerator", 3:"relax" },
            "3guardroom" : { 1:"break bits", 2:"roll around" },
        }
    }
};

record choice_info {
    int limit;
    string action;
    string cl;
    boolean[item] it;
};

choice_info[string][string][string][string] dread_state = {
    "Forest": {
        "cabin" : { 
            "kitchen" : { 
                "spice rack" : new choice_info(9999, "[S #1d] get dread tarragon", "", { }),
                "flour mill" : new choice_info(9999, "[S #1b] get bone flour", "mus", 
                                               $items[old dry bone]),
                "disposal" : new choice_info(1, "banish stench from forest", "", { })
            },
            "basement" : { 
                "newspapers" : new choice_info(10, "[F] get freddies", "", { }),
                "diary" : new choice_info(9999, "[T #1a] get spooky dmg buff", "", { }),
                "lockbox" : new choice_info(1, "[G #4] get auditor's badge", "", $items[replica key]),
                "banana" : new choice_info(9999, "[G #2a] make lock impression", "", 
                                           $items[wax banana]),
            },
            "attic" : { 
                "music box" : new choice_info(1, "[G #2b] banish spooky from forest (AT gets parts)", 
                                              "", { }),
                "wolfsbane" : new choice_info(1, "fewer werewolves in forest", "", { }),
                "rafters" : new choice_info(1, "fewer vampires in castle", "", { }),
                "photo albums" : new choice_info(9999, "gain moxie", "", { }),
            },
        },
        "tree" : { 
            "climb" : { 
                "stomp" : new choice_info(1, "drop blood kiwi", "", { }),
                "kick" : new choice_info(1, "banish sleaze from forest", "", { }),
                "shiny thing" : new choice_info(1, "[W #1] get moon-amber", "", { }),
            },
            "fire tower" : { 
                "siren" : new choice_info(1, "fewer ghosts in village", "", { }),
                "footlocker" : new choice_info(10, "[F] get freddies", "", { }),
                "weights" : new choice_info(9999, "gain muscle", "", { }),
            },
            "root" : { 
                "look up" : new choice_info(1, "[B #1a] wait for blood kiwi", "", { }),
                "look down" : new choice_info(9999, "get seed pod", "", { }),
                "hole" : new choice_info(9999, "get owl folder", "", $items[folder holder]),
            },
        },
        "burrows" : { 
            "heat" : { 
                "pull cork" : new choice_info(1, "banish hot from forest", "", { }),
                "play" : new choice_info(9999, "[T #1b] get hot dmg buff", "", { }),
                "melt" : new choice_info(9999, "[C #1] get cool iron ingot", "", 
                                         $items[old ball and chain]),
            },
            "cold" : { 
                "read" : new choice_info(1, "banish cold from forest", "", { }),
                "listen" : new choice_info(9999, "gain mysticality", "", { }),
                "drink" : new choice_info(9999, "gain HP buff", "", { }),
            },
            "smelly" : { 
                "smash" : new choice_info(1, "fewer bugbears in forest", "", { }),
                "dig" : new choice_info(10, "[F] get freddies", "", { }),
            },
        }
    },
    "Village": {
        "square" : { 
            "schoolhouse" : { 
                "erasers" : new choice_info(1, "fewer ghosts from village", "", { }),
                "desk" : new choice_info(10, "get ghost pencil", "", { }),
                "carvings" : new choice_info(9999, "gain mysticality", "", { }),
            },
            "blacksmith" : { 
                "furnace" : new choice_info(1, "banish cold from village", "", { }),
                "till" : new choice_info(10, "[F] get freddies", "", { }),
                "anvil" : new choice_info(9999, "[C #2] smith cooling iron item", "", 
                                          $items[hothammer, cool iron ingot, warm fur]),
            },
            "gallows" : { 
                "paint noose" : new choice_info(1, "banish spooky from village", "", { }),
                "trap door" : new choice_info(1, "try to get gallows item", "", { }),
                "stand around" : new choice_info(9999, "stand around", "", { }),
                "lever" : new choice_info(1, "drop clanmate", "", { }),
            },
        },
        "skid row" : { 
            "sewers" : { 
                "unclog" : new choice_info(1, "banish stench from village", "", { }),
                "slosh" : new choice_info(9999, "[T #1c] get stench dmg buff", "", { }),
            },
            "tenements" : { 
                "rats" : new choice_info(1, "fewer skeletons in castle", "", { }),
                "paint" : new choice_info(1, "banish sleaze from village", "", { }),
                "bricks" : new choice_info(9999, "gain muscle", "", { }),
            },
            "shack" : { 
                "shelves" : new choice_info(10, "[F] get freddies", "", { }),
                "key" : new choice_info(9999, "[G #3] get replica key", "", 
                                        $items[intricate music box parts, complicated lock impression]),
                "polish" : new choice_info(9999, "[W #2] polish moon-amber", "", $items[moon-amber]),
                "assemble" : new choice_info(9999, "", "", 
                                        // music box parts must be first for proper output below
                                        $items[intricate music box parts, dreadsylvanian clockwork key]),
                "boxes" : new choice_info(9999, "get old fuse", "", { }),
            },
        },
        "estate" : { 
            "plot" : { 
                "gates" : new choice_info(1, "fewer zombies in village", "", { }),
                "graves" : new choice_info(10, "[F] get freddies", "", { }),
                "tombstones" : new choice_info(9999, "[T #1d] get sleaze dmg buff", "", { }),
            },
            "quarters" : { 
                "ovens" : new choice_info(1, "banish hot from village", "", { }),
                "pie" : new choice_info(9999, "[S #2] make shepherd's pie", "", 
                                        $items[dread tarragon, bone flour, dreadful roast, 
                                               stinking agaricus]),
                "cabinets" : new choice_info(9999, "gain moxie", "", { }),
            },
            "suite" : { 
                "whistle" : new choice_info(1, "fewer werewolves in forest", "", { }),
                "nightstand" : new choice_info(9999, "[B #1b] get eau de mort", "", { }),
                "loom" : new choice_info(9999, "[V #1] get ghost shawl", "", $items[ghost thread]),
            },
        }
    },
    "Castle": {
        "tower" : { 
            "laboratory" : { 
                "lamp" : new choice_info(1, "fewer bugbears in forest", "", { }),
                "brains" : new choice_info(1, "fewer zombies in village", "", { }),
                "repair machine" : new choice_info(1, "repair machine", "", $items[skull capacitor]),
                "use machine" : new choice_info(9, "use machine", "", { }),
                "still" : new choice_info(9999, "[B #2] get kiwitini", "", 
                                          $items[blood kiwi, eau de mort]),
            },
            "books" : { 
                "incantations" : new choice_info(1, "fewer skeletons in castle", "", { }),
                "secrets" : new choice_info(9999, "gain mysticality", "", { }),
                "jewelry" : new choice_info(9999, "[W #3 once] learn moon-amber recipe", "", { }),
            },
            "bedroom" : { 
                "parrot" : new choice_info(1, "banish sleaze from castle", "", { }),
                "dresser" : new choice_info(10, "[F] get freddies", "", { }),
                "magic fingers" : new choice_info(9999, "get MP buff", "", { }),
            },
        },
        "hall" : { 
            "ballroom" : { 
                "organ" : new choice_info(1, "fewer vampires in castle", "", { }),
                "trip" : new choice_info(9999, "[Z #1] or gain moxie", "", 
                                         $items[muddy skirt, dreadsylvanian seed pod]),
            },
            "kitchen" : { 
                "freezer" : new choice_info(1, "banish cold from castle", "", { }),
                "hang out" : new choice_info(9999, "[T #1e] get cold dmg buff", "", { }),
            },
            "dining room" : { 
                "roast" : new choice_info(1, "[S #1a] get dreadful roast", "", { }),
                "dishes" : new choice_info(1, "banish stench from castle", "", { }),
                "levitate" : new choice_info(1, "[G #1] get wax banana", "mys", { }),
            },
        },
        "dungeons" : { 
            "cell block" : { 
                "flush" : new choice_info(1, "banish spooky from castle", "", { }),
                "pushups" : new choice_info(9999, "gain muscle", "", { }),
                "nap" : new choice_info(9999, "gain mp", "", { }),
            },
            "boiler room" : { 
                "steam" : new choice_info(1, "banish hot from castle", "", { }),
                "incinerator" : new choice_info(10, "[F] get freddies", "", { }),
                "relax" : new choice_info(9999, "gain stats", "", { }),
            },
            "guardroom" : { 
                "break bits" : new choice_info(1, "[S #1c] get stinking agaricus", "", { }),
                "roll around" : new choice_info(9999, "get weaken enemy buff", "", { }),
            },
        }
    }
};

record dread_choice {
    string zone;
    string loc;
    string subloc;
    string choice;
};

dread_choice[string] log2choice = {
    "acquired some dread tarragon": new dread_choice("Forest", "cabin", "kitchen", "spice rack"),
    "made some bone flour": new dread_choice("Forest", "cabin", "kitchen", "flour mill"),
    "made the forest less stinky": new dread_choice("Forest", "cabin", "kitchen", "disposal"),
    "recycled some newspapers": new dread_choice("Forest", "cabin", "basement", "newspapers"),
    "read an old diary": new dread_choice("Forest", "cabin", "basement", "diary"),
    "got a Dreadsylvanian auditor's badge": new dread_choice("Forest", "cabin", "basement", "lockbox"),
    "made an impression of a complicated lock": new dread_choice("Forest", "cabin", "basement", "banana"),
    "made the forest less spooky": new dread_choice("Forest", "cabin", "attic", "music box"),
    "drove some werewolves out of the forest": new dread_choice("Forest", "cabin", "attic", "wolfsbane"),
    "drove some vampires out of the castle": new dread_choice("Forest", "cabin", "attic", "rafters"),
    "flipped through a photo album": new dread_choice("Forest", "cabin", "attic", "photo albums"),
    "knocked some fruit loose": new dread_choice("Forest", "tree", "climb", "stomp"),
    "wasted some fruit": new dread_choice("Forest", "tree", "climb", "stomp"),
    "made the forest less sleazy": new dread_choice("Forest", "tree", "climb", "kick"),
    "acquired a chunk of moon-amber": new dread_choice("Forest", "tree", "climb", "shiny thing"),
    "drove some ghosts out of the village": new dread_choice("Forest", "tree", "fire tower", "siren"),
    "rifled through a footlocker": new dread_choice("Forest", "tree", "fire tower", "footlocker"),
    "lifted some weights": new dread_choice("Forest", "tree", "fire tower", "weights"),
    "got a blood kiwi": new dread_choice("Forest", "tree", "root", "look up"),
    "got a cool seed pod": new dread_choice("Forest", "tree", "root", "look down"),
    "made the forest less hot": new dread_choice("Forest", "burrows", "heat", "pull cork"),
    "got intimate with some hot coals": new dread_choice("Forest", "burrows", "heat", "play"),
    "made a cool iron ingot": new dread_choice("Forest", "burrows", "heat", "melt"),
    "made the forest less cold": new dread_choice("Forest", "burrows", "cold", "read"),
    "listened to the forest's heart": new dread_choice("Forest", "burrows", "cold", "listen"),
    "drank some nutritious forest goo": new dread_choice("Forest", "burrows", "cold", "drink"),
    "drove some bugbears out of the forest": new dread_choice("Forest", "burrows", "smelly", "smash"),
    "found and sold a rare baseball card": new dread_choice("Forest", "burrows", "smelly", "dig"),
    "drove some ghosts out of the village": new dread_choice("Village", "square", "schoolhouse", "erasers"),
    "collected a ghost pencil": new dread_choice("Village", "square", "schoolhouse", "desk"),
    "read some naughty carvings": new dread_choice("Village", "square", "schoolhouse", "carvings"),
    "made the village less cold": new dread_choice("Village", "square", "blacksmith", "furnace"),
    "looted the blacksmith's till": new dread_choice("Village", "square", "blacksmith", "till"),
    "made a cool iron breastplate": new dread_choice("Village", "square", "blacksmith", "anvil"),
    "made a cool iron helmet": new dread_choice("Village", "square", "blacksmith", "anvil"),
    "made some cool iron greaves": new dread_choice("Village", "square", "blacksmith", "anvil"),
    "made the village less spooky": new dread_choice("Village", "square", "gallows", "paint noose"),
    "was hung by a clanmate": new dread_choice("Village", "square", "gallows", "trap door"),
    "hung a clanmate": new dread_choice("Village", "square", "gallows", "lever"),
    "made the village less stinky": new dread_choice("Village", "skid row", "sewers", "unclog"),
    "swam in a sewer": new dread_choice("Village", "skid row", "sewers", "slosh"),
    "drove some skeletons out of the castle": new dread_choice("Village", "skid row", "tenements", "rats"),
    "made the village less sleazy": new dread_choice("Village", "skid row", "tenements", "paint"),
    "moved some bricks around": new dread_choice("Village", "skid row", "tenements", "bricks"),
    "looted the tinker's shack": new dread_choice("Village", "skid row", "shack", "shelves"),
    "made a complicated key": new dread_choice("Village", "skid row", "shack", "key"),
    "polished some moon-amber": new dread_choice("Village", "skid row", "shack", "polish"),
    "made a clockwork bird": new dread_choice("Village", "skid row", "shack", "assemble"),
    "got some old fuse": new dread_choice("Village", "skid row", "shack", "boxes"),
    "drove some zombies out of the village": new dread_choice("Village", "estate", "plot", "gates"),
    "robbed some graves": new dread_choice("Village", "estate", "plot", "graves"),
    "read some lurid epitaphs": new dread_choice("Village", "estate", "plot", "tombstones"),
    "made the village less hot": new dread_choice("Village", "estate", "quarters", "ovens"),
    "made a shepherd's pie": new dread_choice("Village", "estate", "quarters", "pie"),
    "raided some naughty cabinets": new dread_choice("Village", "estate", "quarters", "cabinets"),
    "drove some werewolves out of the forest": new dread_choice("Village", "estate", "suite", "whistle"),
    "got a bottle of eau de mort": new dread_choice("Village", "estate", "suite", "nightstand"),
    "made a ghost shawl": new dread_choice("Village", "estate", "suite", "loom"),
    "drove some bugbears out of the forest": new dread_choice("Castle", "tower", "laboratory", "lamp"),
    "drove some zombies out of the village": new dread_choice("Castle", "tower", "laboratory", "brains"),
    "fixed The Machine": new dread_choice("Castle", "tower", "laboratory", "repair machine"),
    //"": new dread_choice("Castle", "tower", "laboratory", "use machine"),
    "made a blood kiwitini": new dread_choice("Castle", "tower", "laboratory", "still"),
    "drove some skeletons out of the castle": new dread_choice("Castle", "tower", "books", "incantations"),
    "read some ancient secrets": new dread_choice("Castle", "tower", "books", "secrets"),
    "learned to make a moon-amber necklace": new dread_choice("Castle", "tower", "books", "jewelry"),
    "made the castle less sleazy": new dread_choice("Castle", "tower", "bedroom", "parrot"),
    "raided a dresser": new dread_choice("Castle", "tower", "bedroom", "dresser"),
    "got magically fingered": new dread_choice("Castle", "tower", "bedroom", "magic fingers"),
    "drove some vampires out of the castle": new dread_choice("Castle", "hall", "ballroom", "organ"),
    "twirled on the dance floor": new dread_choice("Castle", "hall", "ballroom", "trip"),
    "made the castle less cold": new dread_choice("Castle", "hall", "kitchen", "freezer"),
    "frolicked in a freezer": new dread_choice("Castle", "hall", "kitchen", "hang out"),
    "got some roast beast": new dread_choice("Castle", "hall", "dining room", "roast"),
    "made the castle less stinky": new dread_choice("Castle", "hall", "dining room", "dishes"),
    "got a wax banana": new dread_choice("Castle", "hall", "dining room", "levitate"),
    "made the castle less spooky": new dread_choice("Castle", "dungeons", "cell block", "flush"),
    "did a whole bunch of pushups": new dread_choice("Castle", "dungeons", "cell block", "pushups"),
    "took a nap on a prison cot": new dread_choice("Castle", "dungeons", "cell block", "nap"),
    "made the castle less hot": new dread_choice("Castle", "dungeons", "boiler room", "steam"),
    "sifted through some ashes": new dread_choice("Castle", "dungeons", "boiler room", "incinerator"),
    "relaxed in a furnace": new dread_choice("Castle", "dungeons", "boiler room", "relax"),
    "got some stinking agaric": new dread_choice("Castle", "dungeons", "guardroom", "break bits"),
    "rolled around in some mushrooms": new dread_choice("Castle", "dungeons", "guardroom", "roll around"),
};

boolean[string] subloc_locks = {
    "attic": true,
    "fire tower": true, 
    "schoolhouse": true, 
    "suite": true, 
    "laboratory": true, 
    "ballroom": true 
};

void print_options(string color)
{
    print("Available options:", color);
    print("-b: Steps for boss bugbear Hard Mode", color);
    print("-c: Steps to acquire Cool Irons outfit", color);
    print("-f: Places to get Freddy Kruegerands", color);
    print("-g: Steps for boss ghost Hard Mode", color);
    print("-s: Steps for boss skeleton Hard Mode", color);
    print("-v: Steps for boss vampire Hard Mode", color);
    print("-w: Steps for boss werewolf Hard Mode", color);
    print("-z: Steps for boss zombies Hard Mode", color);
    print("-?: Print help information and stop", color);
}

void print_help(string color)
{
    print("Command format:", color);
    print("");
    print("dredlisto [option] ...", color);
    print("");
    print_options(color);
    print("");
    print("Options may be combined into a single word, e.g., '-b -c -f' is the same as '-bcf'.", color);
}

void main(string args)
{
    acli_command_parameters acp = acli_parse(args, "bcfgsvwz?");
    if (count(acp.errors) > 0) {
        foreach n, e in acp.errors {
            print(e, "red");
        }
        print_options("red");
        return;
    }
    if (acp.flags["?"]) {
        print_help("black");
        return;
    }
    boolean quest_selected = false;
    boolean[string] quests_selected;
    foreach quest, bool in acp.flags {
        if (bool) {
            quest_selected = true;
            quests_selected["[" + to_upper_case(quest)] = true;
        }
    }

    buffer buf = visit_url("clan_raidlogs.php");
    // Get the part of the raid logs pertaining to Dreadsylvania
    matcher logmatch = create_matcher("(Dreadsylvania:.*)Loot Distribution:.*(Hobopolis:.*)Loot Distribution:.*(The Slime Tube:.*)Loot Distribution:.*", buf);
    if (! find(logmatch)) {
        logmatch = create_matcher("(Dreadsylvania:.*)Loot Distribution:.*(Hobopolis:.*)Loot Distribution:.*", buf);
        if (! find(logmatch)) {
            print("Found nothing", "red");
            print("");
            return;
        }
    } 
    string dreadlog = group(logmatch, 1);
    // Identify which zones are exhausted, and remove them from dread_state
    matcher defeatmatch 
        = create_matcher("Your clan has defeated <b>([0-9,]*)</b> monster.s. in the ([^.]*)", dreadlog);
    int[string] zone_defeats;
    while (find(defeatmatch))
        zone_defeats[group(defeatmatch, 2)] = to_int(group(defeatmatch, 1));
    // If there have been 1000 defeats, the zone is closed to noncombats
    foreach zone, defeats in zone_defeats {
        if (defeats >= 1000) {
            print("Dread zone " + zone + " is closed to noncombats.", "red");
            remove dread_state[zone];
        }
    }
    /*
    foreach zone, defeats in zone_defeats {
        print(zone + ": " + to_string(defeats));
    }
    */
    // Identify in which locations players have already done something
    string[int] player_acts;
    string[int] other_acts;
    matcher eventmatch = create_matcher("([^>(]*)[(]#[0-9]*[)]([^<(]*)", dreadlog);
    while (find(eventmatch)) {
        string who = trim(group(eventmatch, 1));
        string what = trim(group(eventmatch, 2));
        if (what.contains_text("defeated") || what.contains_text("carriageman")
                || what.contains_text("distributed")) {
            continue;
        }
        if (log2choice contains what) {
            if (who == my_name()) {
                player_acts[player_acts.count()] = what;
            } else {
                other_acts[other_acts.count()] = what;
            }
        } else {
            print(who + ": " + what, "olive");
            if (substring(what, 0, 8) == "unlocked") {
                string unlock = substring(what, 9);
                if (unlock == "the lab")  subloc_locks["laboratory"] = false;
                else if (unlock == "the ballroom")  subloc_locks["ballroom"] = false;
                else if (unlock == "the attic of the cabin")  subloc_locks["attic"] = false;
                else if (unlock == "the schoolhouse")  subloc_locks["schoolhouse"] = false;
                else if (unlock == "the fire tower")  subloc_locks["fire tower"] = false; // ???
                else if (unlock == "the master suite")  subloc_locks["suite"] = false;    // ???
            }
        }
    }
    // Eliminate locations in which the player has already had a noncombat
    foreach i, what in player_acts {
        dread_choice choice = log2choice[what];
        string zone = choice.zone;
        string loc = choice.loc;
        if (dread_state contains zone && dread_state[zone] contains loc) {
            print("You already " + what, "red");
            remove dread_state[zone][loc];
        }
    }
    // Identify which limited choices have been exhausted by others
    foreach i, what in other_acts {
        dread_choice choice = log2choice[what];
        string zone = choice.zone;
        string loc = choice.loc;
        string subloc = choice.subloc;
        string ch = choice.choice;
        if (dread_state contains zone && dread_state[zone] contains loc
                && dread_state[zone][loc] contains subloc
                && dread_state[zone][loc][subloc] contains ch) {
            choice_info info = dread_state[zone][loc][subloc][ch];
            info.limit = info.limit - 1;
            if (info.limit <= 0) {
                print("Someone already " + what, "red");
                remove dread_state[zone][loc][subloc][ch];
            }
        }
    }
    // ---- Print choices 
    class c = my_class();
    foreach nz, nl, nsl, cn, choice in choice_order {
        string zone = substring(nz, 1);
        if (! (dread_state contains zone))  continue;
        string loc = substring(nl, 1);
        if (! (dread_state[zone] contains loc))  continue;
        string subloc = substring(nsl, 1);
        if (! (dread_state[zone][loc] contains subloc))  continue;
        if (! (dread_state[zone][loc][subloc] contains choice))  continue;
        choice_info data = dread_state[zone][loc][subloc][choice];
        // If no specific quest requested, print info.
        // Otherwise, if action not part of a requested quest, skip.
        if (quest_selected) {
            boolean skip = true;
            foreach q, b in quests_selected {
                if (data.action.index_of(q) == 0) {
                    skip = false;
                    break;
                }
            }
            if (skip) {
                continue;
            }
        }
        string color = "black";
        string needs = "";
        // Grey out if needed items are missing
        if (data.it.count() > 0) {
            string prefix = "";
            foreach i in data.it {
                if (i == $item[ghost thread] && item_amount(i) < 10) {
                    color = "gray";
                    needs = to_string(10-item_amount(i)) + " " + to_string(i);
                }
                else if (i == $item[intricate music box parts] && choice == "assemble"
                         && item_amount(i) < 3) {
                    color = "gray";
                    needs = to_string(3-item_amount(i)) + " " + to_string(i);
                    prefix = ", ";
                }
                else if (item_amount(i) < 1) {
                    color = "gray";
                    needs = needs + prefix + to_string(i);
                    prefix = ", ";
                }
            }
            if (needs != "") {
                needs = " (needs " + needs + ")";
            }
        }
        // Grey out if wrong class
        if (c != $class[seal clubber] && c != $class[turtle tamer]) {
            if (subloc == "climb" || choice == "flour mill") {
                needs = needs + " <MUS>";
                color = "gray";
            }
        }
        if (c != $class[pastamancer] && c != $class[sauceror]) {
            if (subloc == "books" || choice == "levitate" || choice == "pie" ) {
                needs = needs + " <MYS>";
                color = "gray";
            }
        }
        if (c != $class[disco bandit] && c != $class[accordion thief]) {
            if (subloc == "shack" || choice == "still") {
                needs = needs + " <MOX>";
                color = "gray";
            }
        }
        // See if area is locked
        if (subloc_locks contains subloc && subloc_locks[subloc]) {
            subloc = subloc + "<LOCKED>";
        }
        print(loc + "->" + subloc + "->" + choice + ": " + data.action + needs, color);
    }
}

