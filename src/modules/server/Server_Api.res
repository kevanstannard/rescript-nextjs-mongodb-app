type statusCode = [#BadRequest | #Forbidden | #NotFound | #ServerError | #Success]

let sendJson = (res: Next.Res.t, code: statusCode, payload: {..}) => {
  Next.Res.statusCode(res, code)
  Next.Res.sendJson(res, payload)
}
