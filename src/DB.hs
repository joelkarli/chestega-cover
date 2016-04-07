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

initTable conn = do
                tables <- getTables conn
                if "games" `elem` tables then run conn deleteGamesQuery []
                                         else run conn createTableQuery []

updateTable args conn = do
                pgn <- readFile filename
                stmt <- prepare conn insertGameQuery
                executeMany stmt (gamesToSqlList (pgnToGames filename pgn))
                where filename = head $ tail args

gamesToSqlList games = [[toSql (white g), toSql (black g), toSql (date g), toSql (event g), toSql (site g), toSql (result g), toSql (annotation g)] | g <- games]

createTableQuery = "CREATE TABLE games (\
                   \white VARCHAR(255) NOT NULL,\
                   \black VARCHAR(255) NOT NULL,\
                   \date VARCHAR(255),\
                   \event VARCHAR(255),\
                   \site VARCHAR(255),\
                   \result VARCHAR(255),\
                   \annotation TEXT,\
                   \PRIMARY KEY (white, black));"

deleteGamesQuery = "DELETE FROM games;"

insertGameQuery = "INSERT INTO games VALUES (?, ?, ?, ?, ?, ?, ?);"