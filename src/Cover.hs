import System.Environment
import Data.ByteString.Lazy as B
import Encoding

main :: IO()
main = do
    args <- getArgs
    bytes <- B.readFile $ Prelude.head args
    Prelude.writeFile (Prelude.head args ++ ".enc") (capitals bytes)