import System.Environment
import Data.ByteString.Lazy as B
import Database.HDBC
import Database.HDBC.Sqlite3
import Data.Maybe (fromMaybe)
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

findGamesFromCaps [] conn res = return $ Prelude.reverse res
findGamesFromCaps (c : caps) conn res = do
                                r <- quickQuery' conn gameStartingWithQuery [toSql (c : "%")]
                                findGamesFromCaps caps conn (convRow (Prelude.head r) : res)
                        where convRow [sqlWhite, sqlBlack, sqlDate, sqlEvent, sqlSite, sqlResult, sqlRound, sqlAnnotation] = Game {white = fromSql sqlWhite, black = fromSql sqlBlack, date = fromSql sqlDate, event = fromSql sqlEvent, site = fromSql sqlSite, result = fromSql sqlResult, Game.round = fromSql sqlRound, annotation = fromSql sqlAnnotation}

gameStartingWithQuery = "SELECT white, black, date, event, site, result, round, annotation FROM games \
                        \WHERE white LIKE ? \
                        \ORDER BY RANDOM() \
                        \LIMIT 1;"