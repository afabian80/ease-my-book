module Main where

import Data.Char (isAlpha)
import Data.List (isPrefixOf)

main :: IO ()
main = do
        sampleHtml <- readFile "samples/sample.html"
        --sampleHtml <- readFile "/Users/akos/Documents/Programming/Haskell/coca-hs/html-samples/TheSecretGarden.html"
        putStrLn $ unwords $ collectWords False sampleHtml

collectWords :: Bool -> String -> [String]
collectWords _ [] = []
collectWords inBody text@(x:xs)
        | isAlpha x =
                if inBody
                        then aWord : collectWords inBody (dropWhile isAlpha text)
                        else collectWords inBody (dropWhile isAlpha text)
        | x == '<' = collectWords updateInBody (dropWhile (/= '>') xs)
        | otherwise = collectWords inBody xs
        where
                aWord = takeWhile isAlpha text
                updateInBody = inBody || "body " `isPrefixOf` xs || "body>" `isPrefixOf` xs
