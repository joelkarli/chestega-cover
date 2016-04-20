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

prop_noFirst4Bits :: Property
prop_noFirst4Bits =
    forAll wordGen
    (\w -> firstBits (lastBits w) == 0)

properties :: [Property]
properties = [prop_noLast4Bits, prop_noFirst4Bits]

main :: IO ()
main = mapM_ quickCheck properties
