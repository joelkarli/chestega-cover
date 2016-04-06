module Game
( Game(..)
) where

data Game = Game { white :: String
                 , black :: String
                 , day :: Int
                 , month :: Int
                 , year :: Int
                 , event :: String
                 , site :: String
                 , result :: String
                 , annotation :: String
                 } deriving (Show)