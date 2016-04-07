module PGN
( 
) where

import qualified Text.Parsec as P
import Control.Monad.Identity (Identity)
import Game

parse rule = P.parse rule "(source)"

gameParser :: P.ParsecT String () Identity [String]
gameParser = do
            event <- eventParser
            site <- siteParser
            date <- dateParser
            white <- whiteParser
            black <- blackParser
            result <- resultParser
            P.char '\n'
            annotation <- annotationParser
            return [event, site, date, white, black, result, annotation]



pgnAttrParser :: String -> P.ParsecT String () Identity String
pgnAttrParser s = do
                P.char '['
                P.string s
                P.spaces
                P.char '"'
                value <- P.manyTill (P.noneOf "\"\n") (P.char '"')
                P.string "]\n"
                return value

unimportantAttrParser :: P.ParsecT String () Identity String
unimportantAttrParser = do
                    P.char '['
                    P.many P.letter
                    P.spaces
                    P.char '"'
                    P.many (P.noneOf "\"\n")
                    P.string "\"]\n"

annotationParser :: P.ParsecT String () Identity String
annotationParser = P.manyTill (P.noneOf "") (P.string "\n\n")

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
