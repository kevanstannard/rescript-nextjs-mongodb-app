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

let withBody = (req: Next.Req.t, res: Next.Res.t, callback): Promise.t<unit> => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      sendError(res, #BadRequest, "Body is missing from request")
      Promise.resolve()
    }
  | Some(body) => callback(body)
  }
}

let withCurrentUser = (req, res, callback): Promise.t<unit> => {
  let {currentUser} = Server_Middleware.getRequestData(req)
  switch currentUser {
  | None => {
      sendError(res, #Forbidden, "Not logged in")
      Promise.resolve()
    }
  | Some(currentUser) => callback(currentUser)
  }
}
