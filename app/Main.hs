module Main where
import Data.List.Split (splitOn)

docs :: String
docs = "Write `:hi`, `:wink` or `:?`, `:!` and see it tmojilate into emojis :wink"

tmoji :: String -> String
tmoji text = parse $ splitOn " " text

parse :: [String] -> String
parse wds = case wds of
  w:ws -> eval(w) ++" "++ parse ws
  [] -> ""

eval :: String -> String
eval wrd = case wrd of
  ':':cs -> colon cs
  _ -> wrd

colon :: String -> String
colon wrd = case wrd of
  "hi" -> "🙋🏻"
  "wink" -> "😉"
  "?" -> "❓"
  "!" -> "❗"
  _ -> wrd

cli :: IO ()
cli = do
  line <- getLine
  if line == ":q"
    then putStrLn $ tmoji "Goodbye :hi"
    else do
      putStrLn $ tmoji line
      cli
  

main :: IO ()
main = do
  putStrLn $ tmoji docs
  cli
