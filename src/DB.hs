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

-- |Creates the game table if it does not already exist
initTable :: IConnection conn => conn -> IO Integer
initTable conn = run conn createTableQuery []

-- |Reads a pgn file, then inserts all the games in the pgn file into the game table
updateTable :: IConnection conn => [FilePath] -> conn -> IO ()
updateTable args conn = do
                pgn <- readFile $ head args
                stmt <- prepare conn insertGameQuery
                executeMany stmt (gamesToSqlList (pgnToGames (head args) pgn))

-- |Converts a list of games to SqlValues
gamesToSqlList :: [Game] -> [[SqlValue]]
gamesToSqlList games = [[toSql (white g), toSql (black g), toSql (date g), toSql (event g), toSql (site g), toSql (result g), toSql (Game.round g), toSql (annotation g)] | g <- games]

-- |A SQL query which creates the game table
createTableQuery :: [Char]
createTableQuery = "CREATE TABLE IF NOT EXISTS games (\
                   \white VARCHAR(255) NOT NULL,\
                   \black VARCHAR(255) NOT NULL,\
                   \date VARCHAR(255) NOT NULL,\
                   \event VARCHAR(255),\
                   \site VARCHAR(255),\
                   \result VARCHAR(255),\
                   \round VARCHAR(255) NOT NULL,\
                   \annotation TEXT,\
                   \PRIMARY KEY (white, black, date, round));"

-- |A SQL query which inserts a new game into the database
insertGameQuery :: [Char]
insertGameQuery = "INSERT INTO games VALUES (?, ?, ?, ?, ?, ?, ?, ?);"