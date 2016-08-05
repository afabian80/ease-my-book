module Main where

import           Data.Char          (toLower)
import           Data.Maybe         (fromMaybe)
import qualified Data.Set           as Set
import           Database           (dbToSets, findRoot, readDB, wordCategory)
import           System.Environment (getArgs)
import           System.Exit        (die)
import           Text.Printf        (printf)
import           TextProcessor      (collectWords, getHtmlBody, collectSentences)

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
        let body = getHtmlBody html

        putStrLn "Collecting sentences..."
        let originalSentences = collectSentences body
        cocaDB <- readDB

        let originalWords = collectWords body
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

        let greenRootWords = map (findRoot cocaDB) greenWords
        let redRootWords = map (findRoot cocaDB) redWords

        let greenWordCategories = map (\w -> wordCategory w greenSets (lowerLimit + 1)) greenWords
        let redWordCategories = map (\w -> wordCategory w redSets (upperLimit + 1)) redWords

        let rawGreenStat = zip3 greenWordCategories greenWords greenRootWords
        let rawRedStat = zip3 redWordCategories redWords redRootWords

        putStrLn "Saving green statistics file..."
        writeFile "green.txt" (unlines $ map showZip rawGreenStat)

        putStrLn "Saving red statistics file..."
        writeFile "red.txt" (unlines $ map showZip rawRedStat)

        putStrLn "Done."

showZip :: (Maybe Int, String, Maybe String) -> String
showZip (category,word,root) = c ++ "\t" ++ word ++ "\t" ++ r
        where
                c = case category of
                        Nothing -> "N/A"
                        Just x -> printf "%d" x
                r = fromMaybe "NO ROOT FOUND" root
