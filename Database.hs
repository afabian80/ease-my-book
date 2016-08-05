module Database (readDB, wordCategory, dbToSets, findRoot) where

import           Data.List   (elemIndex)
import qualified Data.Set    as Set
import           Text.Printf

loadSingle :: FilePath -> IO [[String]]
loadSingle path = do
        fileText <- readFile path
        return (map words (lines fileText))

generateFileNames :: [FilePath]
generateFileNames = map (printf genPattern) ([1..25] :: [Integer])
        where
                genPattern = "frequency-lists/basewrd%02d.txt"

loadAll :: [IO [[String]]]
loadAll = map loadSingle generateFileNames

readDB :: IO [[[String]]]
readDB = sequence loadAll

singleDBToSet :: [[String]] -> Set.Set String
singleDBToSet db = Set.fromList $ words $ unwords $ concat db

dbToSets :: [[[String]]] -> [Set.Set String]
dbToSets = map singleDBToSet

wordInSet :: String -> Set.Set String -> Bool
wordInSet = Set.member

wordCategory :: String -> [Set.Set String] -> Int -> Maybe Int
wordCategory w sets offset = fmap (+ offset) $ elemIndex True $ map (wordInSet w) sets

findRootInRow :: String -> [String] -> Maybe String
findRootInRow w row = if w `elem` row
        then Just (head row)
        else Nothing

findRootInSingleDB :: String -> [[String]] -> Maybe String
findRootInSingleDB w db =
        if null rootVector
                then Nothing
                else head rootVector
        where
                rootVector = filter (/= Nothing) $ map (findRootInRow w) db

findRoot :: [[[String]]] -> String -> Maybe String
findRoot dbs w =
        if null rootVector
                then Nothing
                else head rootVector
        where
                rootVector = filter (/= Nothing) $ map (findRootInSingleDB w) dbs
