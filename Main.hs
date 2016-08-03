module Main where

import Data.Text (pack, unpack, breakOn)
import Data.List.Split (splitOn)
import BookCleaner (clean, transform)
import Database (readDB)

main :: IO ()
main = do
        sampleHtml <- readFile "clash.html"
        let (_, htmlBody) = breakOn (pack "<body") (pack sampleHtml)
        let cleanBody = clean $ transform $ unpack htmlBody
        let sentences = splitOn "\n" cleanBody
        let cleanSentences = filter (/= ".") sentences
        --putStrLn $ unlines $ map (\x -> show (fst x :: Integer) ++ ": " ++ snd x) (zip [1..100] cleanSentences)
        cocaDB <- readDB
        putStrLn $ unlines (cocaDB !! 0)
        print "Done"

-- collectWords :: String -> [String]
-- collectWords [] = []
-- collectWords text@(x:xs)
--         | isAlpha x = takeWhile isAlpha text : collectWords (dropWhile isAlpha text)
--         | x == '<' = collectWords (dropWhile (/= '>') xs)
--         | otherwise = collectWords xs
