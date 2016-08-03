module Database (readDB) where

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
