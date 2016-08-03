module Database (readDB) where

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
db2set db = Set.fromList $ words $ concat db

dbs2sets :: [[String]] -> [Set.Set String]
dbs2sets = map db2set

-- wordCategory :: String -> [[String]] -> Integer
-- wordCategory w db =
