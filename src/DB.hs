import Database.HDBC
import Database.HDBC.Sqlite3

main :: IO()
main = do
    conn <- connectSqlite3 "chestega.db"
    disconnect conn