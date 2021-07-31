type cookieOptions = {secure: bool}

type options = {
  password: string,
  cookieName: string,
  cookieOptions: cookieOptions,
}

let getSession: Next.Req.t => Js.Nullable.t<'a> = %raw(`
  function getSession(req) {
    return req.session;
  }
`)

@module("next-iron-session")
external applySession: (Next.Req.t, Next.Res.t, options) => Promise.t<unit> = "applySession"

@send @scope("session")
external setString: (Next.Req.t, string, string) => unit = "set"

@send @scope("session")
external getString: (Next.Req.t, string) => Js.Nullable.t<string> = "get"

@send @scope("session")
external unset: (Next.Req.t, string) => unit = "unset"

@send @scope("session")
external save: Next.Req.t => Promise.t<unit> = "save"

// Note: If you use req.session.destroy() in an API route,
// you need to make sure this route will not be cached.
// To do so, either call this route via a POST request
// fetch("/api/logout", { method: "POST" })
// or add cache-control: no-store, max-age=0
// to its response.
@send @scope("session")
external destroy: Next.Req.t => unit = "destroy"
