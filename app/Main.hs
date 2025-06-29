module Main where

tmoji :: String -> String
tmoji text = unlines $ map (parse . words) (lines text)

parse :: [String] -> String
parse wds = case wds of
  w:ws -> unwords [eval w, parse ws]
  [] -> ""

eval :: String -> String
eval wrd = case wrd of
  '@':wd -> wd ++ trans wd
  ':':wd -> let w = trans wd in
    if w == "" then wd else w
  _ -> wrd

trans :: String -> String
trans wd = case wd of
  "hi" -> "🙋🏻"
  "wink" -> "😉"
  "?" -> "❓"
  "!" -> "❗"
  _ -> ""

main :: IO ()
main = getContents >>= putStr . tmoji
