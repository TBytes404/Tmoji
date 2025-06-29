module Main where

import Data.List.Split (splitOn)
-- (splitOn " " text) 

text :: String
text = ":Hi there buddy, how are you :?"

expect :: String
expect = "🙋🏻 there buddy, how are you ❓"

parse :: [String] -> String
parse wds = case wds of
  w:ws -> eval(w) ++" "++ parse ws
  [] -> ""

eval :: String -> String
eval wrd = case wrd of
  ':':"Hi" -> "🙋🏻"
  ':':"?" -> "❓"
  _ -> wrd

main :: IO ()
main = putStr $ parse $ (splitOn " " text) 
