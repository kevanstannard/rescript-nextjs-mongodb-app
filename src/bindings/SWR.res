type fetcher<'a> = string => Promise.t<'a>

type swr<'a> = {data: Js.Undefined.t<'a>, error: Js.Undefined.t<exn>}

@module("swr")
external useSWR: (string, fetcher<'a>) => swr<'a> = "default"
