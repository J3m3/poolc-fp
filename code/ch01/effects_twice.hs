main :: IO ()
main = do
  firstName <- getLine
  secondName <- getLine -- called twice with same param
  putStrLn ("Hi, " ++ firstName ++ secondName)
  putStrLn "--------"
  putStrLn "--------" -- called twice with same param
  putStrLn "Today's weather: ..."