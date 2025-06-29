module Main where

tmoji :: String -> String
tmoji text = unlines $ map (parse . words) (lines text)

parse :: [String] -> String
parse tags = case tags of
  t:ts -> unwords [eval t, parse ts]
  [] -> ""

eval :: String -> String
eval tag = case tag of
  '@':word -> word ++ trans word
  ':':word -> let emoji = trans word in
    if emoji == "" then word else emoji
  _ -> tag

tmojiMap :: [(String, String)]
tmojiMap = [("hi", "🙋🏻"), ("wink", "😉"), ("?", "❓"), ("!", "❗")]

trans :: String -> String
trans word = maybe "" id (lookup word tmojiMap)

main :: IO ()
main = getContents >>= putStr . tmoji
