/*
RETURNEES
Prints a list of clannies who have gone from inactive to active since the last time it was run.
Preserves ranks.
*/

since r19904;    // template string support

import <clanlib>

string ROSTER_FILE = get_clan_name() + "_roster.txt";

record clan_member {
    string name;
    boolean was_active;
    string rank;
};


void main()
{
    // Get clannies
    cl_clannie[int] clannies = get_clannies();
    // Get previous roster
    clan_member[int] roster;
    file_to_map(ROSTER_FILE, roster);
    
    // Report departed players
    foreach id, mem in roster {
        if (!(clannies contains id)) {
            print(`{mem.name} has left`, "red");
        }
    }
    
    // Report newly-active players, while creating updated roster
    clan_member[int] new_roster;
    foreach id, clannie in clannies {
        // Report activity change
        if (roster contains id) {
            clan_member mem = roster[id];
            if (mem.was_active != clannie.is_active) {
                if (clannie.is_active) {
                    print(`{clannie.name}, previously {mem.rank}, has returned!`, 
                          "green");
                } else {
                    print(`{clannie.name} has gone inactive`, "red");
                }
            }
        } else {
            // Someone joined!
            if (clannie.is_active) {
                print(`{clannie.name} #{id} has joined!`, "green");
            } else {
                print(`{clannie.name} #{id} (inactive) added to roster`);
            }
        }
        // Add to updated roster
        clan_member mem;
        mem.name = clannie.name;
        mem.was_active = clannie.is_active;
        string rank = clannie.rank;
        if (rank == "Missing") {
            string newrank = roster[id].rank;
            if (newrank != "") {
                rank = newrank;
            }
        }
        mem.rank = rank;
        new_roster[id] = mem;
    }
    
    // Save current roster
    map_to_file(new_roster, ROSTER_FILE); 

    print("Done.");
    print("");
}
