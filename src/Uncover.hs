import System.Environment
import Data.ByteString.Lazy as B
import PGN
import Encoding

main :: IO()
main = do
    args <- getArgs
    f <- Prelude.readFile $ Prelude.head args
    B.writeFile (Prelude.last args) (uncapitals (pgnToWhiteCaps (Prelude.head args) f))