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

parse rule = P.parse rule "(source)"

pgnToGames text = map mappingToGame mappings
            where mappings = case parse pgnParser text of
                                Right v -> v
                                Left err -> [[("", "")]]

mappingToGame mapping = Game {white = pgnWhite, black = pgnBlack, day = pgnDay, month = pgnMonth, year = pgnYear, event = pgnEvent, site = pgnSite, result = pgnResult, annotation = pgnAnnotation}
                    where map = M.fromList mapping
                          pgnWhite = fromMaybe "" (M.lookup "White" map)
                          pgnBlack = fromMaybe "" (M.lookup "Black" map)
                          pgnDate = fromMaybe "" (M.lookup "Date" map)
                          pgnEvent = fromMaybe "" (M.lookup "Event" map)
                          pgnSite = fromMaybe "" (M.lookup "Site" map)
                          pgnResult = fromMaybe "" (M.lookup "Result" map)
                          pgnAnnotation = fromMaybe "" (M.lookup "Annotation" map)
                          pgnDay = pgnDateDay pgnDate
                          pgnMonth = pgnDateMonth pgnDate
                          pgnYear = pgnDateYear pgnDate


pgnDateYear pgnDate = if head strYear == '?' then 0 else read strYear
                    where strYear = head $ splitOn "." pgnDate

pgnDateMonth pgnDate = if head strMonth == '?' then 0 else read strMonth
                    where strMonth = head $ tail $ splitOn "." pgnDate

pgnDateDay pgnDate = if head strDay == '?' then 0 else read strDay
                    where strDay = last $ splitOn "." pgnDate

pgnParser :: P.ParsecT String () Identity [[(String, String)]]
pgnParser = P.many gameParser

gameParser :: P.ParsecT String () Identity [(String, String)]
gameParser = do
            mapping <- P.many attrLineParser
            P.char '\n'
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
            P.char '\n'
            return pair

annotationParser :: P.ParsecT String () Identity String
annotationParser = P.manyTill P.anyChar (P.string "\n\n")
