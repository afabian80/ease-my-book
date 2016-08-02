module Database (loadSingle, generateFileNames) where

import Text.Printf

loadSingle :: FilePath -> IO [String]
loadSingle path = do
        fileText <- readFile path
        return (lines fileText)

-- loadAll :: [IO [String]]
-- loadAll =

generateFileNames :: [String]
generateFileNames = map (printf genPattern) ([1..25] :: [Integer])
        where
                genPattern = "frequency-lists/basewrd%02d.txt"
