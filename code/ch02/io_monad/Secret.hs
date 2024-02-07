module Secret where

import GHC.IO (unsafePerformIO)

data World = World deriving (Show)

printStr :: String -> World -> World
printStr str !w = unsafePerformIO (putStrLn str >> return w)

readStr :: World -> (String, World)
readStr !w = unsafePerformIO (getLine >>= \s -> return (s, w))