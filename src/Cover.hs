import System.Environment
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
    Prelude.writeFile (Prelude.head args ++ ".pgn") (gameStr (capitals bytes) conn)
    disconnect conn

gameStr caps conn = "Test"

capsToGames caps conn = Prelude.map (findGameStartingWith conn) caps

findGameStartingWith conn c = do
            gameAsList <- sg
            return $ convRow gameAsList
            where sg = sqlGame conn c
                  convRow [sqlWhite, sqlBlack, sqlDate, sqlEvent, sqlSite, sqlResult, sqlRound, sqlAnnotation] = Game {white = fromSql sqlWhite, black = fromSql sqlBlack, date = fromSql sqlDate, event = fromSql sqlEvent, site = fromSql sqlSite, result = fromSql sqlResult, Game.round = fromSql sqlRound, annotation = fromSql sqlAnnotation}

sqlGame conn c = do
                qry <- quickQuery' conn gameStartingWithQuery [toSql (c : "%")]
                return $ Prelude.head qry

gameStartingWithQuery = "SELECT white, black, date, event, site, result, round, annotation FROM games \
                        \WHERE white LIKE ? \
                        \ORDER BY RANDOM() \
                        \LIMIT 1;"