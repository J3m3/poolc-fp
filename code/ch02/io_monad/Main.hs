{- HLINT ignore -}
{-# OPTIONS_GHC -Wno-noncanonical-monad-instances #-}

module Main where

import Control.Monad
import Secret

whatIsYourName :: IO ()
whatIsYourName = do
  putStrLn "What is your name?"
  firstName <- getLine -- same input!
  lastName <- getLine -- same input!
  putStrLn ("Hello, " ++ firstName ++ " " ++ lastName)

------------------------------------------------------------

{-
  data World = World

  printStr :: String -> World -> World
  readStr :: World -> (String, World)

  A compiler should know these are different "World"s.
-}

whatIsYourPureName :: World -> World
whatIsYourPureName world =
  let (_, world') = printStrT "What is your name?" world
      (firstName, world'') = readStr world'
      (lastName, world''') = readStr world''
   in printStr ("Hello, " ++ firstName ++ " " ++ lastName) world'''

------------------------------------------------------------

{-
  What if user copies "World"?
  If user can copy "World", this model can break.
-}

------------------------------------------------------------

type WorldT a = World -> (a, World)

readStrT :: WorldT String
readStrT = readStr

printStrT :: String -> WorldT ()
printStrT str world = ((), printStr str world)

(>>>=) :: WorldT a           -- World -> (a, World)
        -> (a -> WorldT b)   -- a -> World -> (b, World)
        -> WorldT b          -- World -> (b, World)
m >>>= f = uncurry f . m

whatIsYourPureNameT :: WorldT ()
whatIsYourPureNameT =
  printStrT "What is your name?" >>>= \_ ->
  readStrT                       >>>= \firstName ->
  readStrT                       >>>= \lastName ->
  printStrT ("Hello, " ++ firstName ++ " " ++ lastName)

------------------------------------------------------------

newtype WorldM a = Action (World -> (a, World))

readStrM :: WorldM String
readStrM = Action readStr

printStrM :: String -> WorldM ()
printStrM = Action . printStrT

instance Functor WorldM where
  fmap = liftM

instance Applicative WorldM where
  pure a = Action (\world -> (a, world))
  (<*>) = ap

instance Monad WorldM where
  return a = Action (\world -> (a, world))
  Action m >>= f =
    Action
      ( \world ->
          let (a, world') = m world
              Action f' = f a
           in f' world'
      )

runWorldM :: WorldM a -> World -> (a, World)
runWorldM (Action m) = m

whatIsYourPureNameM :: WorldM ()
whatIsYourPureNameM = do
  printStrM "What is your name?"
  firstName <- readStrM
  lastName <- readStrM
  printStrM ("Hello, " ++ firstName ++ " " ++ lastName)

main :: IO ()
main = undefined