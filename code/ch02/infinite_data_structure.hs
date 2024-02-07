{-
The Classic Turner's Sieve
(Attributed to David Turner (SASL Language Manual, 1975))

sieve [2 ..]
2 : sieve [x | x <- xs, x `mod` 2 /= 0]
  where
    xs = [3 ..]

2 : 3 : sieve [x | x <- xs, x `mod` 3 /= 0]
  where
    xs = [x | x <- [4 ..], x `mod` 2 /= 0]

2 : 3 : sieve [x | x <- xs, x `mod` 4 /= 0]
  where
    xs = [
      x | x <- [
        x | x <- [5 ..],
          x `mod` 2 /= 0
      ], x `mod` 3 /= 0
    ]

2 : 3 : 5 : sieve [x | x <- xs, x `mod` 5 /= 0]
  where
    xs = [
      x | x <- [
        x | x <- [
          x | x <- [6 ..],
            x `mod` 2 /= 0
        ], x `mod` 3 /= 0
      ], x `mod` 4 /= 0
    ]
...
-}
sieve :: [Int] -> [Int]
sieve (p : xs) = p : sieve [x | x <- xs, x `mod` p /= 0]

primes :: [Int]
primes = sieve [2 ..]

{-
0 : 1 : Thunk
0 : 1 : zipWith (+) [0, 1, Thunk] [1, Thunk]
0 : 1 : 1 : zipWith (+) [1, 1, Thunk] [1, Thunk]
0 : 1 : 1 : 2 : zipWith (+) [1, 2, Thunk] [2, Thunk]
0 : 1 : 1 : 2 : 3 : zipWith (+) [1, 2, Thunk] [2, Thunk]
0 : 1 : 1 : 2 : 3 : 5 : zipWith (+) [2, 3, Thunk] [3, Thunk]
...
-}
fibs :: [Int]
fibs = 0 : 1 : zipWith (+) fibs (tail fibs)

main :: IO ()
main = do
  putStr "Prime Numbers: "
  print (take 10 primes)

  putStr "Fibonacci Numbers: "
  print (take 10 fibs)
