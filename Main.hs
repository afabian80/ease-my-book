module Main where

import Data.Char (isAlpha)
import Data.List (isPrefixOf)

main :: IO ()
main = do
        sampleHtml <- readFile "sample.html"
        --sampleHtml <- readFile "/Users/akos/Documents/Programming/Haskell/coca-hs/html-samples/TheSecretGarden.html"
        putStrLn $ unwords $ parse False sampleHtml

parse :: Bool -> String -> [String]
parse _ [] = []
parse inBody text@(x:xs)
        | isAlpha x =
                if inBody
                        then aWord : parse inBody (dropWhile isAlpha text)
                        else parse inBody (dropWhile isAlpha text)
        | x == '<' = parse updateInBody (dropWhile (/= '>') xs)
        | otherwise = parse inBody xs
        where
                aWord = takeWhile isAlpha text
                updateInBody = inBody || "body " `isPrefixOf` xs || "body>" `isPrefixOf` xs
