module Main where

import System.Environment (getArgs)
import System.Exit (die)
import Database (readDB)
import TextProcessor (collectWords, collectSentences)

main :: IO ()
main = do
        args <- getArgs
        case args of
                [inputFile] -> run inputFile
                _ -> die "Use parameter: <html-inpu-file>"


run :: FilePath -> IO ()
run inputFile = do
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
        -- putStrLn $ unlines originalWords
