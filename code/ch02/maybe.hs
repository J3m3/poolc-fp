{- HLINT ignore -}

import Prelude hiding (Just, Maybe, Nothing)

data Maybe a = MyNothing | MyJust a
  deriving (Show)

myMap :: (a -> b) -> Maybe a -> Maybe b
myMap _ MyNothing = MyNothing -- pattern matching
myMap f (MyJust x) = MyJust (f x) -- pattern matching

myMap' :: (a -> b) -> Maybe a -> Maybe b
myMap' f x = case x of -- pattern matching
  MyNothing -> MyNothing
  MyJust a -> MyJust (f a)

myReturn :: a -> Maybe a
myReturn x = MyJust x

myReturn' :: a -> Maybe a
myReturn' = MyJust

myBind :: Maybe a -> (a -> Maybe b) -> Maybe b
myBind MyNothing _ = MyNothing -- pattern matching
myBind (MyJust x) f = f x -- pattern matching

myBind' :: Maybe a -> (a -> Maybe b) -> Maybe b
myBind' m f = case m of -- pattern matching
  MyNothing -> MyNothing
  MyJust x -> f x

myApply :: Maybe (a -> b) -> Maybe a -> Maybe b
myApply MyNothing _ = MyNothing -- pattern matching
myApply (MyJust f) m = myMap f m -- pattern matching

myApply' :: Maybe (a -> b) -> Maybe a -> Maybe b
myApply' f x = case f of -- pattern matching
  MyNothing -> MyNothing
  MyJust g -> case x of -- pattern matching
    MyNothing -> MyNothing
    MyJust y -> MyJust (g y)

instance Functor Maybe where
  fmap :: (a -> b) -> Maybe a -> Maybe b
  fmap = myMap

instance Applicative Maybe where
  pure :: a -> Maybe a
  pure = MyJust

  (<*>) :: Maybe (a -> b) -> Maybe a -> Maybe b
  (<*>) = myApply

instance Monad Maybe where
  (>>=) :: Maybe a -> (a -> Maybe b) -> Maybe b
  (>>=) = myBind