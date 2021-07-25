type alphabet = string
type size = int
type generator = unit => string

@module("nanoid")
external customAlphabet: (alphabet, size) => generator = "customAlphabet"

@module("nanoid")
external generate: generator = "nanoid"
