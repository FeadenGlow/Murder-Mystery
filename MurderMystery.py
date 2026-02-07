import itertools

people = ["George", "John", "Robert", "Barbara", "Christine", "Yolanda"]
men = {"George", "John", "Robert"}
women = {"Barbara", "Christine", "Yolanda"}

rooms = ["Bathroom", "Dining Room", "Kitchen", "Living Room", "Pantry", "Study"]
weapons = ["Bag", "Firearm", "Gas", "Knife", "Poison", "Rope"]

def solve():
    solutions = []

    for room_perm in itertools.permutations(rooms):
        room_of = dict(zip(people, room_perm))

        # Clue 2: Barbara and Yolanda are Study/Bathroom (one each)
        if {room_of["Barbara"], room_of["Yolanda"]} != {"Study", "Bathroom"}:
            continue

        for weapon_perm in itertools.permutations(weapons):
            weapon_of = dict(zip(people, weapon_perm))

            # ---------- Clue 1 ----------
            # man in kitchen: not rope, knife, bag, and not firearm
            kitchen_person = next(p for p in people if room_of[p] == "Kitchen")
            if kitchen_person not in men:
                continue
            if weapon_of[kitchen_person] in {"Rope", "Knife", "Bag", "Firearm"}:
                continue

            # ---------- Clue 3 ----------
            bag_person = next(p for p in people if weapon_of[p] == "Bag")
            if bag_person in {"Barbara", "George"}:
                continue
            if room_of[bag_person] in {"Bathroom", "Dining Room"}:
                continue

            # ---------- Clue 4 ----------
            rope_person = next(p for p in people if weapon_of[p] == "Rope")
            if rope_person not in women:
                continue
            if room_of[rope_person] != "Study":
                continue

            # ---------- Clue 5 ----------
            living_person = next(p for p in people if room_of[p] == "Living Room")
            if living_person not in {"John", "George"}:
                continue

            # ---------- Clue 6 ----------
            knife_person = next(p for p in people if weapon_of[p] == "Knife")
            if room_of[knife_person] == "Dining Room":
                continue

            # ---------- Clue 7 ----------
            study_weapon = next(weapon_of[p] for p in people if room_of[p] == "Study")
            pantry_weapon = next(weapon_of[p] for p in people if room_of[p] == "Pantry")
            if weapon_of["Yolanda"] in {study_weapon, pantry_weapon}:
                continue

            # ---------- Clue 8 ----------
            if weapon_of["George"] != "Firearm":
                continue

            # ---------- Final ----------
            # Gas in Pantry → murderer
            pantry_person = next(p for p in people if room_of[p] == "Pantry")
            if weapon_of[pantry_person] != "Gas":
                continue

            solutions.append((room_of, weapon_of))

    return solutions


solutions = solve()

for room_of, weapon_of in solutions:
    print("SOLUTION:")
    for p in people:
        print(f"{p:10} -> {room_of[p]:12} with {weapon_of[p]}")
    murderer = next(p for p in people if room_of[p] == "Pantry")
    print("\nMURDERER:", murderer)
