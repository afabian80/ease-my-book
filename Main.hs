module Main where

import           Data.Char          (toLower)
import           Database           (dbToSets, readDB, wordCategory)
import           System.Environment (getArgs)
import           System.Exit        (die)
import           TextProcessor      (collectSentences, collectWords)

main :: IO ()
main = do
        args <- getArgs
        case args of
                [inputFileArg, lowerLimitArg, upperLimitArg] ->
                        run inputFileArg lowerLimit upperLimit
                        where
                                lowerLimit = (read lowerLimitArg :: Int)
                                upperLimit = (read upperLimitArg :: Int)
                _ -> die "Use parameter: <html-inpu-file> <lower> <upper>"


run :: FilePath -> Int -> Int -> IO ()
run inputFile loweLimit upperLimit = do
        html <- readFile inputFile

        let originalSentences = collectSentences html
        let numSentences = length originalSentences
        putStrLn $ "Number of sentences: " ++ show numSentences

        cocaDB <- readDB
        let numDBs = length cocaDB
        putStrLn $ "Number of DBs : " ++ show numDBs
        --putStrLn $ unlines (cocaDB !! 0)

        let originalWords = collectWords html
        let numWords = length originalWords
        putStrLn $ "Number of words: " ++ show numWords

        let lowercaseWords = map (map toLower) originalWords
        let dbSets = dbToSets cocaDB
        let wordCategories = map (`wordCategory` dbSets) lowercaseWords
        let pairs = zip wordCategories lowercaseWords
        putStrLn $ unlines $ map (\(a,b) -> show a ++ ": " ++ show b) pairs
        print "Done."
