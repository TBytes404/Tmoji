```
 ______ ___ ___  ___   ____ ____
|      |   T   T/   \ |    l    j
|      | _   _ Y     Yl__  ||  T
l_j  l_|  \_/  |  O  |__j  ||  |
  |  | |   |   |     /  |  ||  |
  |  | |   |   l     \  `  |j  l
  l__j l___j___j\___/ \____|____j
```

Translate annotated text into emoji 😄

Syntax:
@tag → Places the corresponding emoji _after_ the preceding word.
:tag → Replaces the tag _itself_ with the corresponding emoji.

Rules:
• @ tags attach the emoji after the word (e.g. "@hi" → "hi🙋🏻").
• : tags replace the tag entirely (e.g. ":wink" → "😉").
• If a tag has no emoji mapping, the symbol (@ or :) is stripped and the word is preserved.

Example:
Input: @hi there :! :wink. @no :record
Output: hi🙋🏻 there ❗️ 😉. no record

Easily customize emoji mappings in the source code.

Type `:q` to quit.
