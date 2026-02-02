import Data.List (permutations)

-- Типи даних
data Person = George | John | Robert | Barbara | Christine | Yolanda
  deriving (Eq, Show, Enum, Bounded)

data Room = Bathroom | DiningRoom | Kitchen | LivingRoom | Pantry | Study
  deriving (Eq, Show, Enum, Bounded)

data Weapon = Bag | Firearm | Gas | Knife | Poison | Rope
  deriving (Eq, Show, Enum, Bounded)

type Assignment = [(Person, Room, Weapon)]

people :: [Person]
people = [minBound .. maxBound]

rooms :: [Room]
rooms = [minBound .. maxBound]

weapons :: [Weapon]
weapons = [minBound .. maxBound]

-- Генерація всіх можливих комбінацій
assignments :: [Assignment]
assignments =
  [ zip3 people rs ws
  | rs <- permutations rooms
  , ws <- permutations weapons
  ]

-- Допоміжні функції
roomOf :: Person -> Assignment -> Room
roomOf p a = head [r | (p', r, _) <- a, p' == p]

weaponOf :: Person -> Assignment -> Weapon
weaponOf p a = head [w | (p', _, w) <- a, p' == p]

personInRoom :: Room -> Assignment -> Person
personInRoom r a = head [p | (p, r', _) <- a, r' == r]

weaponInRoom :: Room -> Assignment -> Weapon
weaponInRoom r a = head [w | (_, r', w) <- a, r' == r]

-- Підказки
valid :: Assignment -> Bool
valid a =
  and
    [ -- Clue 1
      let p = personInRoom Kitchen a
          w = weaponInRoom Kitchen a
       in p `elem` [George, John, Robert]
          && w `notElem` [Rope, Knife, Bag, Firearm]

    , -- Clue 2
      (roomOf Barbara a == Study && roomOf Yolanda a == Bathroom)
      || (roomOf Barbara a == Bathroom && roomOf Yolanda a == Study)

    , -- Clue 3
      let bagOwner = head [p | (p, _, w) <- a, w == Bag]
          bagRoom  = roomOf bagOwner a
       in bagOwner `notElem` [Barbara, George]
          && bagRoom `notElem` [Bathroom, DiningRoom]

    , -- Clue 4
      let ropeOwner = head [p | (p, _, w) <- a, w == Rope]
       in ropeOwner `elem` [Barbara, Christine, Yolanda]
          && roomOf ropeOwner a == Study

    , -- Clue 5
      let p = personInRoom LivingRoom a
       in p `elem` [John, George]

    , -- Clue 6
      weaponInRoom DiningRoom a /= Knife

    , -- Clue 7
      let w = weaponOf Yolanda a
       in w /= weaponInRoom Study a
          && w /= weaponInRoom Pantry a

    , -- Clue 8
      weaponOf George a == Firearm

    , -- Final clue
      weaponInRoom Pantry a == Gas
    ]

solutions :: [Assignment]
solutions = filter valid assignments

main :: IO ()
main = do
  let solution = head solutions
      murderer = personInRoom Pantry solution
  putStrLn "Solution:"
  mapM_ print solution
  putStrLn ("\nMurderer: " ++ show murderer)
