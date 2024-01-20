main :: IO ()
main = readFile "sample.txt" >>= putStrLn