module Encoding where

import Data.List
import Data.Char
import Data.Maybe (fromMaybe)
import qualified Data.Map as M
import qualified Data.ByteString.Lazy as B
import qualified Data.Word as W
import Data.Bits ((.&.), (.|.), shiftR, shiftL)

-- |Slices the ByteString, then maps each word to the corresponding Char using charMapping
capitals :: B.ByteString -> String
capitals bs = map (\w -> fromMaybe '0' (M.lookup w charMapping)) $ toInts $ slice bs

-- |Basically reverses capitals to a ByteString by mapping each Char to the corresponding word and then unslicing
uncapitals :: String -> B.ByteString
uncapitals caps = B.pack (unslice (toWords (map (\c -> fromMaybe 16 (M.lookup c intMapping)) caps)))

-- |Slices a ByteString into pieces of 4 Bits
slice :: B.ByteString -> [W.Word8]
slice bs = concatMap (\w -> [shiftR (firstBits w) 4, lastBits w]) $ B.unpack bs

-- |Reverses the slice function. Unifies all the 4 Bit Words to 8 Bit Words
unslice :: [W.Word8] -> [W.Word8]
unslice [] = []
unslice (w:ws) = unify w (head ws) : unslice (tail ws)

-- |Converts a list of Word8 to a list of Int
toInts :: [W.Word8] -> [Int]
toInts = map (fromIntegral :: W.Word8 -> Int)

-- |Converts a list of Int to a list of Word8
toWords :: [Int] -> [W.Word8]
toWords = map (fromIntegral :: Int -> W.Word8)

-- |Returns the first 4 bits of w
firstBits w = (.&.) w 240

-- |Returns the last 4 bits of w
lastBits w = (.&.) w 15

-- |Unifies two 4 Bit Words to an 8 Bit Word
unify x = (.|.) (shiftL x 4)

-- |Maps the integers from 0 to 15 to chars A to P
charMapping :: M.Map Int Char
charMapping = M.fromList [(x, chr (x + 65)) | x <- [0..15]]

-- |Maps the chars from A to P to ints from 0 to 15
intMapping :: M.Map Char Int
intMapping = M.fromList [(c, ord c - 65) | c <- ['A'..'P']]