module BookCleaner (clean, transform) where

import Data.Char (isAlpha)
import Data.List (isPrefixOf)

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
isSpecialChar c = c `elem` ",:-'’ \n"
