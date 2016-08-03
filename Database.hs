module Database (readDB, wordCategoryVector) where

import           Text.Printf
import qualified Data.Set        as Set

loadSingle :: FilePath -> IO [String]
loadSingle path = do
        fileText <- readFile path
        return (lines fileText)

generateFileNames :: [FilePath]
generateFileNames = map (printf genPattern) ([1..25] :: [Integer])
        where
                genPattern = "frequency-lists/basewrd%02d.txt"

loadAll :: [IO [String]]
loadAll = map loadSingle generateFileNames

readDB :: IO [[String]]
readDB = sequence loadAll

db2set :: [String] -> Set.Set String
db2set db = Set.fromList $ words $ unwords db

dbs2sets :: [[String]] -> [Set.Set String]
dbs2sets = map db2set

wordInSet :: String -> Set.Set String -> Bool
wordInSet = Set.member

wordCategoryVector :: String -> [Set.Set String] -> [Bool]
wordCategoryVector w = map (wordInSet w)
