type successStatusCode = [#Success]
type errorStatusCode = [#BadRequest | #Forbidden | #NotFound | #ServerError | #Success]
type statusCode = [successStatusCode | errorStatusCode]

let sendJson = (res: Next.Res.t, code: statusCode, payload: Js.Json.t) => {
  Next.Res.statusCode(res, code)
  Next.Res.sendJson(res, payload)
}

let sendError = (res: Next.Res.t, code: errorStatusCode, error: string) => {
  let payload = {
    "error": error,
  }
  sendJson(res, code, payload->Common_Json.asJson)
}

let sendSuccess = (res: Next.Res.t, payload: 'a) => {
  sendJson(res, #Success, payload->Common_Json.asJson)
}

let withBodyAsJson = (
  req: Next.Req.t,
  res: Next.Res.t,
  next: Js.Json.t => Promise.t<unit>,
): Promise.t<unit> => {
  let body = Server_Middleware.NextRequest.getBodyAsJson(req)
  switch body {
  | None => {
      sendError(res, #BadRequest, "Body is missing from request")
      Promise.resolve()
    }
  | Some(body) => next(body)
  }
}

let withCurrentUser = (req, res, next): Promise.t<unit> => {
  let {currentUser} = Server_Middleware.getRequestData(req)
  switch currentUser {
  | None => {
      sendError(res, #Forbidden, "Not logged in")
      Promise.resolve()
    }
  | Some(currentUser) => next(currentUser)
  }
}
