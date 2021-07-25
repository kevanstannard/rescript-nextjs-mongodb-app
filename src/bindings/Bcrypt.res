type salt

@module("bcrypt") @val
external genSaltPromise: int => Promise.t<salt> = "genSalt"

@module("bcrypt") @val
external hashPromise: (string, salt) => Promise.t<string> = "hash"

@module("bcrypt") @val
external comparePromise: (string, string) => Promise.t<bool> = "compare"
