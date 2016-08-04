module Database (readDB, wordCategory, dbToSets) where

import           Data.List   (elemIndex)
import qualified Data.Set    as Set
import           Text.Printf

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

wordCategory :: String -> [Set.Set String] -> Int -> Maybe Int
wordCategory w sets offset = fmap (+ offset) $ elemIndex True $ map (wordInSet w) sets
