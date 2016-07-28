module Main where

import Data.Char (isAlpha)
import Data.List (isPrefixOf)
import System.IO (openFile, IOMode(ReadMode), hSetEncoding, utf8, hGetContents, hClose)

main :: IO ()
main = do
        handle <- openFile "samples/VeryShortStories2.htm" ReadMode
        hSetEncoding handle utf8
        sampleHtml <- hGetContents handle
        putStrLn $ unwords $ collectWords False sampleHtml
        hClose handle

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
