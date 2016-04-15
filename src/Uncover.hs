import System.Environment

main :: IO()
main = do
    args <- getArgs
    f <- readFile $ head args
    putStrLn "Test"