module Main where
import Data.Maybe (fromMaybe, catMaybes)
import Data.Char (toLower)
import System.IO (hPutStrLn, stderr)
import Data.Map (Map)
import qualified Data.Map as Map

type EmojiMap = Map String String

tmoji :: EmojiMap -> String -> String
tmoji emojiMap text = unlines . map (unwords . map eval . words) . lines $ text
  where

  eval :: String -> String
  eval tag = case tag of
    ':':word -> emojiFor word
    '@':word -> let emoji = emojiFor word in
      if emoji == word then emoji else word ++ emoji
    _ -> tag

  emojiFor :: String -> String
  emojiFor word = fromMaybe word $ Map.lookup (map toLower word) emojiMap

mapTmoji :: String -> EmojiMap
mapTmoji text = Map.fromList . catMaybes $ map parse (lines text)
  where

  parse :: String -> Maybe (String, String)
  parse line = case words line of
    (tag:emoji:_) -> Just(tag, emoji)
    _ -> Nothing

main :: IO ()
main = do
  readFile "USAGE.txt" >>= hPutStrLn stderr
  emojiMap <- mapTmoji <$> readFile "Tmoji.txt"
  getContents >>= putStr . tmoji emojiMap

