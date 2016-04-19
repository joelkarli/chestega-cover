import Test.QuickCheck
import Encoding

allowedWord :: [Int]
allowedWord = [0..127]

wordGen :: Gen Int
wordGen = elements allowedWord

prop_noLast4Bits :: Property
prop_noLast4Bits =
    forAll wordGen
    (\w -> lastBits (firstBits w) == 0)

main :: IO ()
main = quickCheck prop_noLast4Bits
