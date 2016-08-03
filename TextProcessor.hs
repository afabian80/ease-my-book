module TextProcessor (collectWords) where

import Data.Char (isAlpha)

collectWords :: String -> [String]
collectWords [] = []
collectWords text@(x:xs)
        | isAlpha x = takeWhile isAlpha text : collectWords (dropWhile isAlpha text)
        | x == '<' = collectWords (dropWhile (/= '>') xs)
        | otherwise = collectWords xs
