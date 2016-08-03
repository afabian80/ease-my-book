module Main where

import Database (readDB)
import TextProcessor (collectWords, collectSentences)

main :: IO ()
main = do
        html <- readFile "clash.html"

        let originalSentences = collectSentences html
        --putStrLn $ unlines originalSentences

        cocaDB <- readDB
        --putStrLn $ unlines (cocaDB !! 0)

        let originalWords = collectWords html
        -- putStrLn $ unlines originalWords

        print "Done"
