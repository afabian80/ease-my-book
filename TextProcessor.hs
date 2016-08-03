module TextProcessor (collectWords, collectSentences) where

import Data.Char (isAlpha)
import Data.Text (pack, unpack, breakOn)
import BookCleaner (clean, transform)
import Data.List.Split (splitOn)

collectWords :: String -> [String]
collectWords [] = []
collectWords text@(x:xs)
        | isAlpha x = takeWhile isAlpha text : collectWords (dropWhile isAlpha text)
        | x == '<' = collectWords (dropWhile (/= '>') xs)
        | otherwise = collectWords xs

getHtmlBody :: String -> String
getHtmlBody html = unpack $ snd $ breakOn (pack "<body") (pack html)

cleanBody :: String -> String
cleanBody body = clean $ transform body

getSentences :: String -> [String]
getSentences = splitOn "\n"

cleanSentences :: [String] -> [String]
cleanSentences = filter (/= ".")

collectSentences :: String-> [String]
collectSentences = cleanSentences . getSentences . cleanBody . getHtmlBody
