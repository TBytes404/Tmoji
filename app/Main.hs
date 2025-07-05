{-# LANGUAGE TemplateHaskell #-}
module Main where

import Data.Maybe (mapMaybe)
import Data.Char (toLower, isSpace)
import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)
import Data.FileEmbed (embedStringFile)
import Data.Map (Map, fromList, findWithDefault)

type Tag      = String
type Emoji    = String
type EmojiMap = Map Tag Emoji

main :: IO ()
main = do
  hPutStrLn stderr usageText
  args     <- getArgs
  emojiMap <- case args of
    cfg:_  -> mapTmoji . (emojiCfg ++) <$> readFile cfg
    []     -> pure $ mapTmoji emojiCfg
  getContents >>= putStr . tmoji emojiMap 
  where
  usageText, emojiCfg :: String
  usageText = $(embedStringFile "USAGE.txt")
  emojiCfg  = $(embedStringFile "Tmoji.txt")

tmoji :: EmojiMap -> String -> Emoji
tmoji emojiMap = unlines . map (concatMap eval . split) . lines
  where
  eval :: String -> Emoji
  eval (':':word) = emojiFor word word
  eval ('<':word) = emojiFor "" word ++ word
  eval ('>':word) = word ++ emojiFor "" word
  eval ('@':word) = emoji ++ word ++ emoji
      where emoji = emojiFor "" word
  eval t = t

  emojiFor :: String -> Tag -> Emoji
  emojiFor fallback word = findWithDefault fallback (map toLower word) emojiMap

mapTmoji :: String -> EmojiMap
mapTmoji = fromList . mapMaybe parse . lines
  where
  parse :: String -> Maybe (Tag, Emoji)
  parse line = case words line of
    tag:emoji:_ -> Just (tag, emoji)
    _           -> Nothing

split :: String -> [String]
split "" = []
split s@(c:_)
  | isSpace c = let (spaces, rest) = span isSpace s
                in spaces : split rest
  | otherwise = let (word, rest) = break isSpace s
                in word : split rest
