{-# LANGUAGE DeriveFoldable      #-}
{-# LANGUAGE DeriveFunctor       #-}
{-# LANGUAGE InstanceSigs        #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Monad () where

newtype ListMonad a = ListMonad { getListMonad :: [a] } deriving (Functor, Foldable)

instance Applicative ListMonad where
  pure :: a -> ListMonad a
  pure x = ListMonad [x]

  (<*>) :: ListMonad (a -> b) -> ListMonad a -> ListMonad b
  _ <*> ListMonad [] = ListMonad []
  ListMonad gs <*> ListMonad xs = ListMonad [g x | x <- xs, g <- gs]

instance Monad ListMonad where
  (>>=) :: ListMonad a -> (a -> ListMonad b) -> ListMonad b
  ListMonad xs >>= g = ListMonad (concatMap (getListMonad . g) xs)

-- Function Monad

-- functor instance
--fmap2 :: (a -> b) -> f a -> f b
--fmap2 :: (a -> b) -> ((->) e) a) -> ((-> e) b)
--fmap2 :: (a -> b) -> (e -> a) -> (e -> b)

fmap2 :: (b -> c) -> (a -> b) -> a -> c
fmap2 f g = f . g

-- newtype for Func ((->) r)
newtype Func a b = Func { getFunc :: a -> b }

instance Functor (Func a) where
  fmap :: (b -> c) -> Func a b -> Func a c
  fmap f (Func a) = Func (f . a)
