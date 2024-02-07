{- HLINT ignore -}

import Text.Printf (printf)

f :: IO ()
f = print (undefined + 1)

foo :: a -> Int
foo x = 1

g :: IO ()
g = print (foo undefined + 1)

main :: IO ()
main = g

xs :: [Int]
xs = [1 .. 10] ++ undefined

ys :: [Int]
ys = undefined : [1 .. 10]

testHead :: IO ()
testHead = do
  printf "xs: %d\n" (head xs)
  printf "ys: %d\n" (head ys)

testTail :: IO ()
testTail = do
  let xs' = tail xs
  let ys' = tail ys
  printf "ys: %s\n" (show xs')
  printf "xs: %s\n" (show ys')

testTake :: IO ()
testTake = do
  let xs' = take 5 xs
  let ys' = take 5 ys
  printf "xs: %s\n" (show xs')
  printf "ys: %s\n" (show ys')

testMap :: IO ()
testMap = do
  let f = \x -> x + 1
  let xs' = take 5 (map f xs)
  let ys' = take 5 (map f ys)
  printf "xs: %s\n" (show xs')
  printf "ys: %s\n" (show ys')

testFilter :: IO ()
testFilter = do
  let xs' = take 5 (filter even xs)
  let ys' = take 5 (filter even ys)
  printf "xs: %s\n" (show xs')
  printf "ys: %s\n" (show ys')
