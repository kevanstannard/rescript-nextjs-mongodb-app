let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(forgotPassword: Common_User.ForgotPassword.forgotPassword) => {
      let {client} = Server_Middleware.getRequestData(req)
      client
      ->Server_User.forgotPassword(forgotPassword)
      ->Promise.then(forgotPasswordResult => {
        // TODO: Consider always returning an OK response, so we don't reveal details about an account's existance
        let result: Common_User.ForgotPassword.forgotPasswordResult = switch forgotPasswordResult {
        | Ok() => {
            result: #Ok,
            errors: None,
          }
        | Error(errors) => {
            let errors: Common_User.ForgotPassword.forgotPasswordErrors = {
              forgotPassword: Some(errors),
              email: None,
            }
            {
              result: #Error,
              errors: Some(errors),
            }
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
