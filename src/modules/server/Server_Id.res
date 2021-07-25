// https://zelark.github.io/nano-id-cc/
// 8 characters at 1 id per hour:
// ~271 years needed, in order to have a 1% probability of at least one collision.

// Note that nano is not supported by IE https://github.com/ai/nanoid#ie
let makeShortId = NanoId.customAlphabet(
  "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz",
  8,
)
