module Database (readDB, wordCategoryVector, dbToSets) where

import           Text.Printf
import qualified Data.Set        as Set
--import Data.List (elemIndex)

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

singleDBToSet :: [String] -> Set.Set String
singleDBToSet db = Set.fromList $ words $ unwords db

dbToSets :: [[String]] -> [Set.Set String]
dbToSets = map singleDBToSet

wordInSet :: String -> Set.Set String -> Bool
wordInSet = Set.member

wordCategoryVector :: String -> [Set.Set String] -> [Bool]
wordCategoryVector w = map (wordInSet w)

-- wordCategory :: [Bool] -> Maybe Int
-- wordCategory bs = elemIndex True bs
