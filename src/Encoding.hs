module Encoding
( capitals
, charMapping
) where

import Data.List
import Data.Char
import Data.Maybe (fromMaybe)
import qualified Data.Map as M
import qualified Data.ByteString.Lazy as B
import qualified Data.Word as W
import Data.Bits ((.&.), shiftR)

capitals bs = map (\w -> fromMaybe '0' (M.lookup w charMapping)) $ toInts $ slice bs

slice bs = concatMap (\w -> [shiftR (firstBits w) 4, lastBits w]) $ B.unpack bs

toInts = map (fromIntegral :: W.Word8 -> Int)

firstBits w = (.&.) w 240

lastBits w = (.&.) w 15

charMapping = M.fromList [(x, chr (x + 65)) | x <- [0..15]]