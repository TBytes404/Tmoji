{-# LANGUAGE TemplateHaskell #-}
module Main where

import Data.Char (toLower, isSpace)
import Data.Maybe (mapMaybe)
import Data.Map.Strict (Map, fromList, lookup, findWithDefault)
import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)
import Data.FileEmbed (embedStringFile)
import Prelude hiding (lookup)

type Tag      = String
type Emoji    = String
type EmojiMap = Map Tag Emoji

main :: IO ()
main = do
  hPutStrLn stderr usage
  args     <- getArgs
  emojiMap <- case args of
    cfg:_  -> mapTmoji . (emojiCfg ++) <$> readFile cfg
    []     -> pure $ mapTmoji emojiCfg
  interact (render emojiMap)

usage, emojiCfg :: String
usage    = $(embedStringFile "USAGE.txt")
emojiCfg = $(embedStringFile "Tmoji.txt")

mapTmoji :: String -> EmojiMap
mapTmoji = fromList . normalize . mapMaybe parse . lines
  where
  normalize :: [(Tag, Emoji)] -> [(Tag, Emoji)]
  normalize  = map (\(tag, emoji) -> (map toLower tag, emoji))

  parse :: String -> Maybe (Tag, Emoji)
  parse line = case words line of
    (tag:emoji:_) -> Just (tag, emoji)
    _             -> Nothing

render :: EmojiMap -> String -> String
render emap = concatMap (transform emap) . split

transform :: EmojiMap -> String -> String
transform emap word = case word of
  (':':tag) -> emojiOr tag tag
  ('<':tag) -> emoji tag ++ tag
  ('>':tag) -> tag ++ emoji tag
  ('@':tag) -> e ++ tag ++ e where e = emoji tag
  ('$':tag) -> emojiAnd (\e -> concat [e | _ <- [1..(length tag)]]) tag
  tag       -> tag
  where
  emoji :: Tag -> Emoji
  emoji = emojiOr ""

  emojiOr :: String -> Tag -> Emoji
  emojiOr def tag = findWithDefault def (map toLower tag) emap

  emojiAnd :: (Emoji -> String) -> Tag -> Emoji
  emojiAnd fun tag = maybe tag fun (lookup (map toLower tag) emap)

split :: String -> [String]
split "" = []
split s@(c:_)
  | isSpace c = let (spaces, rest) = span isSpace s
                in spaces : split rest
  | otherwise = let (word, rest) = break isSpace s
                in word : split rest
