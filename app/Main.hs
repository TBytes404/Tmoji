module Main where
import Data.List.Split (splitOn)
import System.IO (hFlush, stdout)

tmoji :: String -> String
tmoji text = parse $ splitOn " " text

parse :: [String] -> String
parse wds = case wds of
  w:ws -> eval(w) ++" "++ parse ws
  [] -> ""

eval :: String -> String
eval wrd = case wrd of
  ':':wd -> trans wd
  '@':wd -> wd ++ trans wd
  _ -> wrd

trans :: String -> String
trans wd = case wd of
  "hi" -> "🙋🏻"
  "wink" -> "😉"
  "?" -> "❓"
  "!" -> "❗"
  _ -> wd

cli :: IO ()
cli = do
  putStr "> "
  hFlush stdout
  line <- getLine
  if line == ":q"
    then putStrLn $ tmoji "\nGoodbye :hi"
    else do
      putStr "▶️ "
      putStrLn $ tmoji line
      cli

main :: IO ()
main = do
  usage <- readFile "USAGE.md"
  putStrLn usage
  cli
