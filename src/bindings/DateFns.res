@module("date-fns/parseISO")
external parseISO: string => Js.Date.t = "default"

@module("date-fns/formatISO")
external formatISO: Js.Date.t => string = "default"

@module("date-fns/format")
external format: (Js.Date.t, string) => string = "default"

@module("date-fns/addHours")
external addHours: (Js.Date.t, int) => Js.Date.t = "default"
