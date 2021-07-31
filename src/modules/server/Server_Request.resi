let getData: Next.Req.t => option<'a>

let get: (Next.Req.t, string) => option<'a>

let getUnsafe: (Next.Req.t, string) => 'a

let set: (Next.Req.t, string, 'a) => unit
