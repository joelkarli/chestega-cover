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
    Prelude.writeFile (Prelude.head args ++ ".pgn") "Test"
    disconnect conn

gameStr caps conn = Prelude.map (iogameToPgn) (capsToGames caps conn)
            where iogameToPgn iog = do
                            g <- iog
                            return (toPgn g)

capsToGames caps conn = Prelude.map (sqlGame conn) caps

sqlGame conn c = do
            stmt <- prepare conn gameStartingWithQuery
            execute stmt [toSql (c : "%")]
            rows <- fetchAllRows' stmt
            return (convRow (Prelude.head rows))
        where convRow [sqlWhite, sqlBlack, sqlDate, sqlEvent, sqlSite, sqlResult, sqlRound, sqlAnnotation] = Game {white = fromSql sqlWhite, black = fromSql sqlBlack, date = fromSql sqlDate, event = fromSql sqlEvent, site = fromSql sqlSite, result = fromSql sqlResult, Game.round = fromSql sqlRound, annotation = fromSql sqlAnnotation}

gameStartingWithQuery = "SELECT white, black, date, event, site, result, round, annotation FROM games \
                        \WHERE white LIKE ? \
                        \ORDER BY RANDOM() \
                        \LIMIT 1;"