type handler
type middleware = (Next.Req.t, Next.Res.t, unit => unit) => unit
type middlewareAsync = (Next.Req.t, Next.Res.t, unit => Promise.t<unit>) => Promise.t<unit>
type methodHandler = (Next.Req.t, Next.Res.t) => unit
type methodHandlerAsync = (Next.Req.t, Next.Res.t) => Promise.t<unit>

@module external nc: unit => handler = "next-connect"

@send external use: (handler, middleware) => handler = "use"
@send external useAsync: (handler, middlewareAsync) => handler = "use"

@send external get: (handler, methodHandler) => handler = "get"
@send external post: (handler, methodHandler) => handler = "post"
@send external put: (handler, methodHandler) => handler = "put"
@send external patch: (handler, methodHandler) => handler = "patch"

@send external getAsync: (handler, methodHandlerAsync) => handler = "get"
@send external postAsync: (handler, methodHandlerAsync) => handler = "post"
@send external putAsync: (handler, methodHandlerAsync) => handler = "put"
@send external patchAsync: (handler, methodHandlerAsync) => handler = "patch"

@send external run: (handler, Next.Req.t, Next.Res.t) => Promise.t<unit> = "run"
