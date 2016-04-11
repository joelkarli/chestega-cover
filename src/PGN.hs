module PGN
( pgnToGames
) where

import Data.Char
import qualified Text.Parsec as P
import Control.Monad.Identity (Identity)
import qualified Data.Map as M
import Data.Maybe (fromMaybe)
import Data.List.Split
import Game

pgnToGames sourcefile text = map mappingToGame mappings
            where mappings = case P.parse pgnParser sourcefile text of
                                Right v -> v
                                Left err -> [[("White", show err)]]

mappingToGame mapping = Game {white = pgnWhite, black = pgnBlack, date = pgnDate, event = pgnEvent, site = pgnSite, result = pgnResult, Game.round = pgnRound, annotation = pgnAnnotation}
                    where mp = M.fromList mapping
                          pgnWhite = fromMaybe "?" (M.lookup "White" mp)
                          pgnBlack = fromMaybe "?" (M.lookup "Black" mp)
                          pgnDate = fromMaybe "?.?.?" (M.lookup "Date" mp)
                          pgnEvent = fromMaybe "?" (M.lookup "Event" mp)
                          pgnSite = fromMaybe "?" (M.lookup "Site" mp)
                          pgnResult = fromMaybe "?" (M.lookup "Result" mp)
                          pgnRound = fromMaybe "?" (M.lookup "Round" mp)
                          pgnAnnotation = fromMaybe "?" (M.lookup "Annotation" mp)

pgnParser :: P.ParsecT String () Identity [[(String, String)]]
pgnParser = P.many gameParser

gameParser :: P.ParsecT String () Identity [(String, String)]
gameParser = do
            mapping <- P.many attrLineParser
            annotation <- annotationParser
            return (("Annotation", annotation) : mapping)

pgnAttrParser :: P.ParsecT String () Identity (String, String)
pgnAttrParser = do
            P.char '['
            key <- P.many P.letter
            P.spaces
            P.char '"'
            value <- P.manyTill (P.noneOf "\"\n") (P.char '"')
            P.char ']'
            return (key, value)

attrLineParser :: P.ParsecT String () Identity (String, String)
attrLineParser = do
            pair <- pgnAttrParser
            P.spaces
            return pair

annotationParser :: P.ParsecT String () Identity String
annotationParser = P.manyTill P.anyChar (P.try (P.count 2 P.newline))
