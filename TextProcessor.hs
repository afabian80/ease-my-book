module TextProcessor (
        collectWords, collectSentences, getHtmlBody,
        occurrences, sampleSentences
        ) where

import           BookCleaner     (clean, transform)
import           Data.Char       (isAlpha, toLower)
import           Data.List.Split (splitOn)
import           Data.Text       (breakOn, pack, unpack)

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

occurrences :: [String] -> String -> Int
occurrences wordList word = length $ filter (== word) wordList

getWords :: String -> [String]
getWords [] = []
getWords text@(x:xs)
        | isAlpha x = takeWhile isAlpha text : getWords (dropWhile isAlpha text)
        | x == '<' = getWords (dropWhile (/= '>') xs)
        | otherwise = getWords xs

partOfSentence :: String -> String -> Bool
partOfSentence word sentence = word `elem` getWords (map toLower sentence)

sampleSentences :: [String] -> Int -> String -> [String]
sampleSentences sentences num word = take num $ filter (partOfSentence word) sentences
