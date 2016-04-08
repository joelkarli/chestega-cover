import System.Environment
import Database.HDBC
import Database.HDBC.Sqlite3
import PGN
import Game

main :: IO()
main = do
    args <- getArgs
    conn <- connectSqlite3 $ last args
    initTable conn
    updateTable args conn
    commit conn
    disconnect conn

initTable conn = run conn createTableQuery []

updateTable args conn = do
                pgn <- readFile $ head args
                stmt <- prepare conn insertGameQuery
                executeMany stmt (gamesToSqlList (pgnToGames (head args) pgn))

gamesToSqlList games = [[toSql (white g), toSql (black g), toSql (date g), toSql (event g), toSql (site g), toSql (result g), toSql (annotation g)] | g <- games]

createTableQuery = "CREATE TABLE IF NOT EXISTS games (\
                   \white VARCHAR(255) NOT NULL,\
                   \black VARCHAR(255) NOT NULL,\
                   \date VARCHAR(255),\
                   \event VARCHAR(255),\
                   \site VARCHAR(255),\
                   \result VARCHAR(255),\
                   \annotation TEXT,\
                   \PRIMARY KEY (white, black));"

insertGameQuery = "INSERT INTO games VALUES (?, ?, ?, ?, ?, ?, ?);"