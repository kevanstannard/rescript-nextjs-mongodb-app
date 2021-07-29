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
