module Main where

import Database (readDB)
import TextProcessor (collectWords, collectSentences)

main :: IO ()
main = do
        sampleHtml <- readFile "clash.html"

        let sentences = collectSentences sampleHtml
        putStrLn $ unlines sentences

        --cocaDB <- readDB
        --putStrLn $ unlines (cocaDB !! 0)

        -- let bookWords = collectWords sampleHtml
        -- putStrLn $ unlines bookWords

        print "Done"
