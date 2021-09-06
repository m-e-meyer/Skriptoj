/*
RETURNEES
Prints a list of clannies who have gone from inactive to active since the last time it was run.
Preserves ranks.
*/

import <clanlib>

string INACTIVES_FILE = "inactives.txt";


void main()
{
    // Get clannies
    cl_clannie[int] clannies = get_clannies();
    // Get the previous inactive list
    string[int] inactives;
    file_to_map(INACTIVES_FILE, inactives);

    // Report newly-active players
    foreach id, rank in inactives {
        cl_clannie c = clannies[id];
        if (c.is_active)
            print("Clannie " + c.name + ", previously " + rank + ", has returned!", 
                  "green");
    }
    // Construct new inactive array
    string[int] inactives_now;
    foreach id, c in clannies {
        if (id == 0)  continue;
        if (! c.is_active) {
            // Rank - if current rank is Missing, use rank from previous list
            string rank = c.rank;
            if (rank == "Missing") {
                string newrank = inactives[id];
                if (newrank != "")  
                    rank = newrank;
            }
            inactives_now[id] = rank;
        }
    }
    map_to_file(inactives_now, INACTIVES_FILE);

    print("Done.");
    print("");
}
