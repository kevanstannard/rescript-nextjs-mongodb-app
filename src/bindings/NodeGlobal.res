type t

@val
external instance: t = "global"

@set_index
external set: (t, string, 'a) => unit = ""

@get_index
external get: (t, string) => option<'a> = ""
