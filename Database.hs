module Database (loadSingle) where



loadSingle :: FilePath -> IO ([String])
loadSingle path = do
        fileText <- readFile path
        return (lines fileText)
