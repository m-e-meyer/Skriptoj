string[string] SIPHON_SPIRITS = {
    "Zoodriver" : "beast 1", 
    "Sloe Comfortable Zoo" : "beast 2", 
    "Sloe Comfortable Zoo on Fire" : "beast 3", 
    "Grasshopper" : "bug 1", 
    "Locust" : "bug 2",
    "Plague of Locusts" : "bug 3", 	
    "Dark & Starry" : "constellation 1",
    "Black Hole" : "constellation 2",
    "Event Horizon" : "constellation 3",
    "Cement Mixer" : "construct 1",
    "Jackhammer" : "construct 2",
    "Dump Truck" : "construct 3",
    "Lollipop Drop" : "Crimbo elf 1",
    "Candy Alexander" : "Crimbo elf 2",	
    "Candicaine" : "Crimbo elf 3",
    "Suffering Sinner" : "demon 1",
    "Suppurating Sinner" : "demon 2",
    "Sizzling Sinner" : "demon 3",
    "Humanitini" : "dude 1",
    "More Humanitini than Humanitini" : "dude 2",
    "Oh, the Humanitini" : "dude 3",
    "Firewater" : "elemental 1",
    "Earth and Firewater" : "elemental 2",
    "Earth, Wind and Firewater" : "elemental 3",
    "Caipiranha" : "fish 1",
    "Flying Caipiranha" : "fish 2",
    "Flaming Caipiranha" : "fish 3",
    "Buttery Knob" : "goblin 1",
    "Slippery Knob" : "goblin 2",
    "Flaming Knob" : "goblin 3",
    "Fauna Libre" : "hippie 1",
    "Chakra Libre" : "hippie 2",
    "Aura Libre" : "hippie 3",
    "Mohobo" : "hobo 1",
    "Moonshine Mohobo" : "hobo 2",
    "Flaming Mohobo" : "hobo 3", 	
    "Great Older Fashioned" : "horror 1",
    "Fuzzy Tentacle" : "horror 2",
    "Crazymaker" : "horror 3",
    "Red Dwarf" : "humanoid 1",
    "Golden Mean" : "humanoid 2",
    "Green Giant" : "humanoid 3",
    "Punchplanter" : "Mer-kin 1",
    "Doublepunchplanter" : "Mer-kin 2",
    "Haymaker" : "Mer-kin 3",
    "Sazerorc" : "orc 1",
    "Sazuruk-hai" : "orc 2",
    "Flaming Sazerorc" : "orc 3",
    "Herring Daiquiri" : "penguin 1",
    "Herring Wallbanger" : "penguin 2",
    "Herringtini" : "penguin 3",
    "Aye Aye" : "pirate 1",
    "Aye Aye, Captain" : "pirate 2",
    "Aye Aye, Tooth Tooth" : "pirate 3",
    "Green Velvet" : "plant 1",
    "Green Muslin" : "plant 2",
    "Green Burlap" : "plant 3",
    "Slimosa" : "slime 1",
    "Extra-slimy Slimosa" : "slime 2",
    "Slimebite" : "slime 3",
    "Drac & Tan" : "undead 1",
    "Transylvania Sling" : "undead 2",
    "Shot of the Living Dead" : "undead 3",
    "Drunken Philosopher" : "weird 1",
    "Drunken Neurologist" : "weird 2",
    "Drunken Astrophysicist" : "weird 3" };

int[item] items_consumed()
{
    int[item] result;
    buffer consumption = visit_url("showconsumption.php");
    matcher m = create_matcher("<tr>[^j]*[^>]*.([^<]*)[^0-9]*([0-9]*)", consumption);
    while (find(m)) {
        //print("* " + group(m, 1) + " " + group(m, 2));
        item i = to_item(group(m, 1));
        if (i != $item[none])
            result[i] = to_int(group(m, 2));
    }
    return result;
}

void main()
{
    int[item] consumed = items_consumed();
    foreach i, src in SIPHON_SPIRITS {
        item it = to_item(i);
        if (consumed[it] <= 0) {
            int n = item_amount(it) + closet_amount(it);
            if (n == 0)
                print(i + " (from " + src + ")");
            else
                print(i + " (" + src.substring(src.length()-1) + ")");
        }
    }
}
