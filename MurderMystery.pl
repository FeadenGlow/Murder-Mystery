:- use_module(library(lists)).

% головний предикат
solve(Murderer) :-
    People = [george, john, robert, barbara, christine, yolanda],
    Rooms  = [bathroom, dining_room, kitchen, living_room, pantry, study],
    Weapons = [bag, firearm, gas, knife, poison, rope],

    % представлення: person(Person, Room, Weapon)
    Solution = [
        person(george, RG, WG),
        person(john, RJ, WJ),
        person(robert, RR, WR),
        person(barbara, RB, WB),
        person(christine, RC, WC),
        person(yolanda, RY, WY)
    ],

    % всі кімнати різні
    permutation(Rooms, [RG, RJ, RR, RB, RC, RY]),
    % всі знаряддя різні
    permutation(Weapons, [WG, WJ, WR, WB, WC, WY]),

    % ---------- Clue 1 ----------
    % чоловік на кухні не мав rope, knife, bag і не firearm
    member(person(P1, kitchen, WK), Solution),
    member(P1, [george, john, robert]),
    \+ member(WK, [rope, knife, bag, firearm]),

    % ---------- Clue 2 ----------
    % Barbara і Yolanda: study / bathroom
    member(person(barbara, RB, _), Solution),
    member(person(yolanda, RY, _), Solution),
    member(RB, [study, bathroom]),
    member(RY, [study, bathroom]),
    RB \= RY,

    % ---------- Clue 3 ----------
    % bag не у Barbara і не у George
    member(person(PB, RBAG, bag), Solution),
    PB \= barbara,
    PB \= george,
    RBAG \= bathroom,
    RBAG \= dining_room,

    % ---------- Clue 4 ----------
    % жінка з rope була в study
    member(person(PR, study, rope), Solution),
    member(PR, [barbara, christine, yolanda]),

    % ---------- Clue 5 ----------
    % у living_room був John або George
    member(person(P5, living_room, _), Solution),
    member(P5, [john, george]),

    % ---------- Clue 6 ----------
    % knife не в dining_room
    member(person(_, RK, knife), Solution),
    RK \= dining_room,

    % ---------- Clue 7 ----------
    % Yolanda не мала зброї зі study і pantry
    member(person(_, study, WS), Solution),
    member(person(_, pantry, WP), Solution),
    member(person(yolanda, _, WY), Solution),
    WY \= WS,
    WY \= WP,

    % ---------- Clue 8 ----------
    % firearm з George
    member(person(george, RG, firearm), Solution),

    % ---------- Final ----------
    % газ у pantry → вбивця
    member(person(Murderer, pantry, gas), Solution).
