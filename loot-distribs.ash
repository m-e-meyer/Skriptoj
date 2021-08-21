/*
    loot-distribs - What loot has everybody gotten?
*/

import "acli.ash"
import "clanlib.ash"


string LOOT_ADJUSTMENTS_FILE = "loot-distribs-adj.txt";

string[string] LOOT_LOCATIONS = {
    "bottle of bloodweiser": "Dreadsylvania", 
    "covers-your-head": "Dreadsylvania", 
    "drapes-you-regally": "Dreadsylvania", 
    "drunkula's bell": "Dreadsylvania", 
    "drunkula's cape": "Dreadsylvania", 
    "drunkula's ring of haze": "Dreadsylvania", 
    "drunkula's silky pants": "Dreadsylvania", 
    "drunkula's wineglass": "Dreadsylvania", 
    "electric kool-aid": "Dreadsylvania", 
    "gets-you-drunk": "Dreadsylvania", 
    "ghost pepper": "Dreadsylvania", 
    "great wolf's beastly trousers": "Dreadsylvania", 
    "great wolf's headband": "Dreadsylvania", 
    "great wolf's left paw": "Dreadsylvania", 
    "great wolf's lice": "Dreadsylvania", 
    "great wolf's right paw": "Dreadsylvania", 
    "great wolf's rocket launcher": "Dreadsylvania", 
    "helps-you-sleep": "Dreadsylvania", 
    "hoa citation pad": "Dreadsylvania", 
    "hoa regulation book": "Dreadsylvania", 
    "hoa zombie eyes": "Dreadsylvania", 
    "hunger&trade; sauce": "Dreadsylvania", 
    "mayor ghost's cloak": "Dreadsylvania", 
    "mayor ghost's gavel": "Dreadsylvania", 
    "mayor ghost's khakis": "Dreadsylvania", 
    "mayor ghost's sash": "Dreadsylvania", 
    "mayor ghost's scissors": "Dreadsylvania", 
    "mayor ghost's toupee": "Dreadsylvania", 
    "protects-your-junk": "Dreadsylvania", 
    "quiets-your-steps": "Dreadsylvania", 
    "skull capacitor": "Dreadsylvania", 
    "thunkula's drinking cap": "Dreadsylvania", 
    "unkillable skeleton's breastplate": "Dreadsylvania", 
    "unkillable skeleton's restless leg": "Dreadsylvania", 
    "unkillable skeleton's sawsword": "Dreadsylvania", 
    "unkillable skeleton's shield": "Dreadsylvania", 
    "unkillable skeleton's shinguards": "Dreadsylvania", 
    "unkillable skeleton's skullcap": "Dreadsylvania", 
    "warms-your-tush": "Dreadsylvania", 
    "wriggling severed nose": "Dreadsylvania", 
    "zombie accordion": "Dreadsylvania", 
    "zombie mariachi hat": "Dreadsylvania", 
    "zombie mariachi pants": "Dreadsylvania", 
    "chester's aquarius medallion": "Hobopolis", 
    "chester's bag of candy": "Hobopolis", 
    "chester's cutoffs": "Hobopolis", 
    "chester's moustache": "Hobopolis", 
    "chester's muscle shirt": "Hobopolis", 
    "chester's sunglasses": "Hobopolis", 
    "frosty's arm": "Hobopolis", 
    "frosty's carrot": "Hobopolis", 
    "frosty's iceball": "Hobopolis", 
    "frosty's nailbat": "Hobopolis", 
    "frosty's old silk hat": "Hobopolis", 
    "frosty's snowball sack": "Hobopolis", 
    "hodgman's almanac": "Hobopolis", 
    "hodgman's bow tie": "Hobopolis", 
    "hodgman's cane": "Hobopolis", 
    "hodgman's disgusting technicolor overcoat": "Hobopolis", 
    "hodgman's garbage sticker": "Hobopolis", 
    "hodgman's harmonica": "Hobopolis", 
    "hodgman's imaginary hamster": "Hobopolis", 
    "hodgman's lobsterskin pants": "Hobopolis", 
    "hodgman's lucky sock": "Hobopolis", 
    "hodgman's metal detector": "Hobopolis", 
    "hodgman's porkpie hat": "Hobopolis", 
    "hodgman's varcolac paw": "Hobopolis", 
    "hodgman's whackin' stick": "Hobopolis", 
    "ol' scratch's ash can": "Hobopolis", 
    "ol' scratch's infernal pitchfork": "Hobopolis", 
    "ol' scratch's manacles": "Hobopolis", 
    "ol' scratch's ol' britches": "Hobopolis", 
    "ol' scratch's stove door": "Hobopolis", 
    "ol' scratch's stovepipe hat": "Hobopolis", 
    "oscus's dumpster waders": "Hobopolis", 
    "oscus's flypaper pants": "Hobopolis", 
    "oscus's garbage can lid": "Hobopolis", 
    "oscus's neverending soda": "Hobopolis", 
    "oscus's pelt": "Hobopolis", 
    "wand of oscus": "Hobopolis", 
    "zombo's empty eye": "Hobopolis", 
    "zombo's grievous greaves": "Hobopolis", 
    "zombo's shield": "Hobopolis", 
    "zombo's shoulder blade": "Hobopolis", 
    "zombo's skull ring": "Hobopolis", 
    "zombo's skullcap": "Hobopolis", 
    "caustic slime nodule": "Slime Tube", 
    "chamoisole": "Slime Tube", 
    "hardened slime belt": "Slime Tube", 
    "hardened slime hat": "Slime Tube", 
    "hardened slime pants": "Slime Tube", 
    "slime-soaked brain": "Slime Tube", 
    "slime-soaked hypophysis": "Slime Tube", 
    "slime-soaked sweat gland": "Slime Tube", 
    "squirming slime larva": "Slime Tube", 
    "the necbromancer's hat": "zObsolete", 
    "the necbromancer's shorts": "zObsolete", 
    "the necbromancer's stein": "zObsolete", 
    "the necbromancer's wizard staff": "zObsolete", 
    "the necbronomicon": "zObsolete", 
    "uncle hobo's belt": "zObsolete", 
    "uncle hobo's epic beard": "zObsolete", 
    "uncle hobo's fingerless tinsel gloves": "zObsolete", 
    "uncle hobo's gift baggy pants": "zObsolete", 
    "uncle hobo's highest bough": "zObsolete", 
    "uncle hobo's stocking cap": "zObsolete" };

string[string] ANNOTATIONS = {
    "bottle of bloodweiser": "consumable", 
    "electric kool-aid": "consumable", 
    "gets-you-drunk": "consumable", 
    "ghost pepper": "consumable", 
    "hunger&trade; sauce": "consumable", 
    "skull capacitor": "consumable", 
    "wriggling severed nose": "hatchling", 
    "caustic slime nodule": "smithing component", 
    "slime-soaked brain": "consumable up to 10", 
    "slime-soaked hypophysis": "consumable up to 10", 
    "slime-soaked sweat gland": "consumable up to 10", 
    "squirming slime larva": "hatchling"
    };

// Add a number of loot distributions to the totals
void add(int[string][string][string] totals, string player, string loot, int n)
{
    string lcplayer = to_lower_case(player);
    string lcloot = to_lower_case(loot);
    string loc = LOOT_LOCATIONS[lcloot];
    totals[loc][lcloot][lcplayer] = totals[loc][lcloot][lcplayer] + n;
}

// Add one loot distribution to the totals
void add(int[string][string][string] totals, string player, string loot)
{
    add(totals, player, loot, 1);
}

/*
Start with adjustments to the array of totals.  Useful for cases of loot distributions outside
the clans, or for distributed items that got zapped to other items.
*/
void initialize(int[string][string][string] totals)
{
    int[string][string] adaptoj; 
    file_to_map(LOOT_ADJUSTMENTS_FILE, adaptoj);
    foreach who, what, num in adaptoj {
        add(totals, who, what, num);
    }
}

/*
Search the clan's raid logs and tally their loot distributions.
*/
void add_distributions(int[string][string][string] totals, string clan)
{
    join_clan(clan);
    print(`Loading raidlogs from {clan}...`);
    dungeon_run[int] raidlogs = load_raidlogs();
    foreach n, drun in raidlogs {
        foreach n, dist in drun.distribs {
            string rcvr = to_lower_case(dist.receiver);
            string loot = to_lower_case(dist.loot);
            string area = LOOT_LOCATIONS[loot];
            if (area == "")  print(dist.loot, "red");
            add(totals, rcvr, loot);
        }
    }
}


void main(string args)
{
    acli_command_parameters acp = acli_parse(args, "hw");
    if (count(acp.errors) > 0 || acp.flags["h"]) {
        if (count(acp.errors) > 0) {
            print(acp.errors[0], "red");
        }
        if (acp.flags["h"]) {
            print("loot-distribs.ash - Search a clan's dungeon raid logs and tally loot distributions");
        }
        print("Usage: loot-distribs [-h] [-w] [clan-name] ...");
        print("PARAMETERS");
        print("clan-name: Name of clan (case-insensitive) for which to gather loot distributions.");
        print(" More than one clan can be specified if you're whitelisted to the others.");
        print(" If no clan is specified, this searches your current clan's logs.");
        print(" You may use " + LOOT_ADJUSTMENTS_FILE + " in your data directory to make adjustments");
        print(" for such things as receiving loot in another clan or loot being zapped to different");
        print(" loot.");
        print("FLAGS:");
        print(" -h: Print this help message");
        print(" -w: Output wiki markup instead of text");
        return;
    }
    boolean wiki_output = acp.flags["w"];

    int[string][string][string] totals;
    initialize(totals);
    
    string saved_clan = get_clan_name();
    if (acp.parameters.count() == 0) {
        add_distributions(totals, saved_clan);
    } else {
        foreach i, cln in acp.parameters {
            add_distributions(totals, cln);
        }
        join_clan(saved_clan);
    }
    
    string last_area = "";
    string last_header = "";
    foreach area, loot, player, n in totals {
        if (last_area != area) {
            if (area == "zObsolete") {
                area = "Obsolete";
            }
            if (wiki_output) {
                print(`=={area}==`);
            } else {
                print("");
                print(`==== {area} ====`);
                print("");
            }
            last_area = area;           
        }
        if (loot != last_header) {
            string loot_ann = loot;
            if (ANNOTATIONS[loot] != "") {
                loot_ann = `{loot} ({ANNOTATIONS[loot]})`;
            }
            if (wiki_output) {
                print(`==={loot_ann}===`);
            } else {
                print(`---- {loot_ann} ----`);
            }
            last_header = loot;
        }
        if (wiki_output) {
            print(`*{player} : '''{n}'''`);
        } else {
            print(`{n} {player}`);
        }
    }
    print("");
    print("Done.");
}

