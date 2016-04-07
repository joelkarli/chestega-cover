module PGN
( 
) where

import Data.Char
import qualified Text.Parsec as P
import Control.Monad.Identity (Identity)
import Game

parse rule = P.parse rule "(source)"

gameParser :: P.ParsecT String () Identity [(String, String)]
gameParser = do
            mapping <- P.many attrLineParser
            P.char '\n'
            annotation <- annotationParser
            return (("annotation", annotation) : mapping)

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
annotationParser = P.manyTill (P.anyChar) (P.string "\n\n")
