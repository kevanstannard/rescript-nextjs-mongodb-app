type err

@module("../../js/load-script")
external loadScript: (. string, unit => unit, err => unit) => unit = "default"

@module("../../js/load-script")
external removeScript: (. string) => unit = "removeScript"
