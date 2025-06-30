module Main where

import Data.Maybe (mapMaybe)
import Data.Char (toLower)
import System.IO (hPutStrLn, stderr)
import Data.Map (Map, fromList, findWithDefault)

type Tag = String
type Emoji = String
type EmojiMap = Map Tag Emoji

main :: IO ()
main = do
  hPutStrLn stderr =<< readFile "USAGE.txt"
  emojiMap <- mapTmoji <$> readFile "Tmoji.txt"
  getContents >>= putStr . tmoji emojiMap

tmoji :: EmojiMap -> String -> Emoji
tmoji emojiMap = unlines . map (unwords . map eval . words) . lines
  where
  eval :: String -> Emoji
  eval (':':word) = emojiFor word
  eval ('@':word) = word ++ emojiFor word
  eval t = t

  emojiFor :: Tag -> Emoji
  emojiFor word = findWithDefault "" (map toLower word) emojiMap

mapTmoji :: String -> EmojiMap
mapTmoji = fromList . mapMaybe parse . lines
  where
  parse :: String -> Maybe (Tag, Emoji)
  parse line = case words line of
    (tag:emoji:_) -> Just(tag, emoji)
    _ -> Nothing
