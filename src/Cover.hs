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
    stmt <- prepare conn gameStartingWithQuery
    executeMany stmt (prepCapsForQuery (capitals bytes))
    rows <- fetchAllRows' stmt
    Prelude.writeFile (Prelude.head args ++ ".pgn") (Prelude.concatMap (\g -> toPgn g) (rowsToGames rows))
    disconnect conn

rowsToGames rows = Prelude.map convRow rows
        where convRow [sqlWhite, sqlBlack, sqlDate, sqlEvent, sqlSite, sqlResult, sqlRound, sqlAnnotation] = Game {white = fromSql sqlWhite, black = fromSql sqlBlack, date = fromSql sqlDate, event = fromSql sqlEvent, site = fromSql sqlSite, result = fromSql sqlResult, Game.round = fromSql sqlRound, annotation = fromSql sqlAnnotation}

prepCapsForQuery caps = [[toSql (c : "%")] | c <- caps]

gameStartingWithQuery = "SELECT white, black, date, event, site, result, round, annotation FROM games \
                        \WHERE white LIKE ? \
                        \ORDER BY RANDOM() \
                        \LIMIT 1;"