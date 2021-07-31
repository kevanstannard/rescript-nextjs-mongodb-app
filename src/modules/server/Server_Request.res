@module("./Server_Request_Js")
external getData_: Next.Req.t => Js.Nullable.t<'a> = "getData"

@module("./Server_Request_Js")
external get_: (Next.Req.t, string) => Js.Nullable.t<'a> = "get"

@module("./Server_Request_Js")
external set_: (Next.Req.t, string, 'a) => unit = "set"

@module("./Server_Request_Js")
external getUnsafe: (Next.Req.t, string) => 'a = "get"

let getData = (req: Next.Req.t) => {
  req->getData_->Js.Nullable.toOption
}

let get = (req: Next.Req.t, key: string): option<'a> => {
  req->get_(key)->Js.Nullable.toOption
}

let set = (req: Next.Req.t, key: string, value: 'a): unit => {
  req->set_(key, value)
}
