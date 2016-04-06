import System.Environment
import Database.HDBC
import Database.HDBC.Sqlite3
import PGN

main :: IO()
main = do
    args <- getArgs
    conn <- connectSqlite3 $ last args
    initTable conn
    commit conn
    disconnect conn

initTable conn = do
                tables <- getTables conn
                if "games" `elem` tables then run conn deleteGamesQuery []
                                         else run conn createTableQuery []

createTableQuery = "CREATE TABLE games (\
                   \white VARCHAR(255) NOT NULL,\
                   \black VARCHAR(255) NOT NULL,\
                   \day INTEGER,\
                   \month INTEGER,\
                   \year INTEGER,\
                   \event VARCHAR(255),\
                   \site VARCHAR(255),\
                   \result VARCHAR(255),\
                   \annotation TEXT,\
                   \PRIMARY KEY (white, black));"

deleteGamesQuery = "DELETE FROM games;"
