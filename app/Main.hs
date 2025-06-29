module Main where
import Data.List.Split (splitOn)

docs :: String
docs = "Write `:hi`, `:wink` or `:?`, `:!` and see it translate into emojis :wink :!"

trans :: String -> String
trans text = parse $ splitOn " " text

parse :: [String] -> String
parse wds = case wds of
  w:ws -> eval(w) ++" "++ parse ws
  [] -> ""

eval :: String -> String
eval wrd = case wrd of
  ':':cs -> tmoji cs
  _ -> wrd

tmoji :: String -> String
tmoji wrd = case wrd of
  "hi" -> "🙋🏻"
  "wink" -> "😉"
  "?" -> "❓"
  "!" -> "❗"
  _ -> wrd

cli :: IO ()
cli = do
  line <- getLine
  if line == "exit" || line == "quit"
    then putStrLn $ trans "Goodbye :hi :!"
    else do
      putStrLn $ trans line
      cli
  

main :: IO ()
main = do
  putStrLn $ trans docs
  cli
