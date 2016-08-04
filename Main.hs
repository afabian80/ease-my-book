module Main where

import           Data.Char          (toLower)
import qualified Data.Set           as Set
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
                                lowerLimit = read lowerLimitArg :: Int
                                upperLimit = read upperLimitArg :: Int
                _ -> die "Use parameter: <html-inpu-file> <lower> <upper>"


run :: FilePath -> Int -> Int -> IO ()
run inputFile lowerLimit upperLimit = do
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

        --let whiteSets = take lowerLimit dbSets
        let greenSets = take (upperLimit - lowerLimit) (drop lowerLimit dbSets)
        let redSets = drop upperLimit dbSets

        let greenSetUnion = Set.unions greenSets
        let redSetUnion = Set.unions redSets

        let wordSet = Set.fromList lowercaseWords
        let greenWordSet = Set.intersection greenSetUnion wordSet
        let redWordSet = Set.intersection redSetUnion wordSet
        let greenWords = Set.toList greenWordSet
        let redWords = Set.toList redWordSet

        let greenWordCategories = map (\w -> wordCategory w greenSets (lowerLimit + 1)) greenWords
        let redWordCategories = map (\w -> wordCategory w redSets (upperLimit + 1)) redWords
        let greenPairs = zip greenWordCategories greenWords
        let redPairs = zip redWordCategories redWords
        print "Green pairs:"
        putStrLn $ unlines $ map (\(a,b) -> show a ++ ": " ++ show b) greenPairs

        print "Red pairs:"
        putStrLn $ unlines $ map (\(a,b) -> show a ++ ": " ++ show b) redPairs

        print "Green words:"
        putStrLn $ unlines greenWords

        print "Red words:"
        putStrLn $ unlines redWords
        print "Done."
