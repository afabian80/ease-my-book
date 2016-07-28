module Main where

import Data.Char (isAlpha)
import Data.Text (pack, unpack, breakOn)

main :: IO ()
main = do
        sampleHtml <- readFile "samples/VeryShortStories.htm"
        let (_, htmlBody) = breakOn (pack "<body") (pack sampleHtml)
        let originalWords = collectWords (unpack htmlBody)
        putStrLn $ unwords originalWords

collectWords :: String -> [String]
collectWords [] = []
collectWords text@(x:xs)
        | isAlpha x = takeWhile isAlpha text : collectWords (dropWhile isAlpha text)
        | x == '<' = collectWords (dropWhile (/= '>') xs)
        | otherwise = collectWords xs
