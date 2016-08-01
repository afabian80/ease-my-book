module Main where

import Data.Char (isAlpha)
import Data.Text (pack, unpack, breakOn)
import Data.List.Split (splitOn)
import Data.List (isPrefixOf)


main :: IO ()
main = do
        sampleHtml <- readFile "samples/VeryShortStories.htm"
        let (_, htmlBody) = breakOn (pack "<body") (pack sampleHtml)
        let cleanBody = clean $ transform $ unpack htmlBody
        let sentences = splitOn "\n" cleanBody
        let cleanSentences = filter (/= ".") sentences
        putStrLn $ unlines $ map (\x -> show (fst x :: Integer) ++ ": " ++ snd x) (zip [1..100] cleanSentences)
        --putStrLn (unlines $ map (\x -> show (fst x) ++ ": " ++ snd x) sentences)
        -- let originalWords = collectWords (unpack htmlBody)
        -- putStrLn $ unwords originalWords

-- collectWords :: String -> [String]
-- collectWords [] = []
-- collectWords text@(x:xs)
--         | isAlpha x = takeWhile isAlpha text : collectWords (dropWhile isAlpha text)
--         | x == '<' = collectWords (dropWhile (/= '>') xs)
--         | otherwise = collectWords xs

transform :: String -> String
transform [] = []
transform text@(x:xs)
        | isAlpha x = takeWhile isAlpha text ++ transform (dropWhile isAlpha text)
        | isNewLine x = ' ' : transform xs
        | isSentenceBorder x = x : '\n' : transform xs
        | isSpecialChar x = x : transform xs
        | x == '<' = transform (dropWhile (/= '>') xs)
        | "&nbsp;" `isPrefixOf` text = '\n' : transform (drop 6 text)
        | otherwise = transform xs

clean :: String -> String
clean [] = []
clean (x:xs)
        | isSpace x = ' ' : clean (dropWhile isSpace xs)
        | isNewLine x = '\n' : clean (dropWhile isNewLine xs)
        | otherwise = x : clean xs

isSpace :: Char -> Bool
isSpace c = c == ' '

isNewLine :: Char -> Bool
isNewLine c = c == '\n'

isSentenceBorder :: Char -> Bool
isSentenceBorder c = c `elem` ".;?!"

isSpecialChar :: Char -> Bool
isSpecialChar c = c `elem` ",;:-'’ \n"

-- TODO
-- remove tags
-- remove multiple linebreaks
-- collapse multiple spaces
-- break on [.?!] but also keep them in the text
