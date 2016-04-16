import System.Environment
import Data.Functor
import Data.ByteString.Lazy as B
import Database.HDBC
import Database.HDBC.Sqlite3
import Encoding
import Game

main :: IO()
main = do
    args <- getArgs
    bytes <- B.readFile $ Prelude.head args
    conn <- connectSqlite3 $ Prelude.last args
    games <- findGamesFromCaps (capitals bytes) conn []
    Prelude.writeFile (Prelude.head args ++ ".pgn") (Prelude.concatMap toPgn games)
    disconnect conn

-- |Takes a String with all uppercase letters and finds a random game for every letter in the String
findGamesFromCaps :: IConnection conn => [Char] -> conn -> [Game] -> IO [Game]
findGamesFromCaps [] conn res = return $ Prelude.reverse res
findGamesFromCaps (c : caps) conn res = do
                                r <- quickQuery' conn gameStartingWithQuery [toSql (c : "%")]
                                findGamesFromCaps caps conn (convRow (fromSql <$> Prelude.head r) : res)
                        where convRow [qryWhite, qryBlack, qryDate, qryEvent, qrySite, qryResult, qryRound, qryAnnotation] = Game {white = qryWhite, black = qryBlack, date = qryDate, event = qryEvent, site = qrySite, result = qryResult, Game.round = qryRound, annotation = qryAnnotation}

-- |A SQL query which returns a random game
gameStartingWithQuery :: [Char]
gameStartingWithQuery = "SELECT white, black, date, event, site, result, round, annotation FROM games \
                        \WHERE white LIKE ? \
                        \ORDER BY RANDOM() \
                        \LIMIT 1;"