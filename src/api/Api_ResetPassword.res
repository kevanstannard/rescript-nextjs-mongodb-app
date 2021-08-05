let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(resetPassword: Common_User.ResetPassword.resetPassword) => {
      let {client} = Server_Middleware.getRequestData(req)
      client
      ->Server_User.resetPassword(resetPassword)
      ->Promise.then(resetPasswordResult => {
        let result: Common_User.ResetPassword.resetPasswordResult = switch resetPasswordResult {
        | Ok() => {
            result: #Ok,
            errors: None,
          }
        | Error(errors) => {
            result: #Error,
            errors: Some(errors),
          }
        }
        Server_Api.sendJson(res, #Success, result->Common_Json.asJson)
        Promise.resolve()
      })
    }
  }
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
