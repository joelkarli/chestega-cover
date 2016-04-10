module Game
( Game(..)
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