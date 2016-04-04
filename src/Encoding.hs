module Encoding
( capitals
, charMapping
) where

import Data.List
import Data.Char
import qualified Data.Map as M
import qualified Data.ByteString.Lazy as B
import qualified Data.Word as W
import Data.Bits ((.&.), shiftR)

capitals bs = map (wordMapper) $ toInts $ slice bs
    where wordMapper w = case M.lookup w charMapping of Just v -> v
                                                        Nothing -> '0'

slice bs = concat $ map (\w -> [shiftR (firstBits w) 4, lastBits w]) $ B.unpack bs

toInts ws = map (fromIntegral :: W.Word8 -> Int) ws

firstBits w = (.&.) w 240

lastBits w = (.&.) w 15

charMapping = M.fromList [(x, chr (x + 65)) | x <- [0..15]]