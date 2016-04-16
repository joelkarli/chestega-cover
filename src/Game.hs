module Game
( Game(..)
, toPgn
) where

data Game = Game { white :: String
                 , black :: String
                 , date :: String
                 , event :: String
                 , site :: String
                 , result :: String
                 , round :: String
                 , annotation :: String
                 } deriving (Show)

-- |Returns a pgn attribute with attribute name k and attribute value v
toPgnAttrLine :: [Char] -> [Char] -> [Char]
toPgnAttrLine k v = '[' : k ++ " \"" ++ v ++ "\"]\n"

-- |Returns a pgn representation of the game
toPgn :: Game -> [Char]
toPgn g = toPgnAttrLine "Event" (event g) ++
          toPgnAttrLine "Site" (site g) ++
          toPgnAttrLine "Date" (date g) ++
          toPgnAttrLine "White" (white g) ++
          toPgnAttrLine "Black" (black g) ++
          toPgnAttrLine "Round" (Game.round g) ++
          toPgnAttrLine "Result" (result g) ++ "\n" ++
          annotation g ++ "\n\n"