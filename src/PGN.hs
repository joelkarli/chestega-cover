module PGN
( 
) where

import qualified Text.Parsec as P
import Control.Monad.Identity (Identity)
import Game

parse rule = P.parse rule "(source)"

pgnAttrParser :: String -> P.ParsecT String () Identity String
pgnAttrParser s = do
                P.char '['
                P.string s
                P.spaces
                P.char '"'
                event <- P.manyTill (P.noneOf "\"\n") (P.char '"')
                P.char ']'
                P.char '\n'
                return event

commentParser :: P.ParsecT String () Identity String
commentParser = do
            P.char '{'
            P.manyTill (P.noneOf "}") (P.char '}')

whiteParser :: P.ParsecT String () Identity String
whiteParser = pgnAttrParser "White"

blackParser :: P.ParsecT String () Identity String
blackParser = pgnAttrParser "Black"

dateParser :: P.ParsecT String () Identity String
dateParser = pgnAttrParser "Date"

eventParser :: P.ParsecT String () Identity String
eventParser = pgnAttrParser "Event"

siteParser :: P.ParsecT String () Identity String
siteParser = pgnAttrParser "Site"

resultParser :: P.ParsecT String () Identity String
resultParser = pgnAttrParser "Result"
