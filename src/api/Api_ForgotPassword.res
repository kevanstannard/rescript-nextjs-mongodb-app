let makePayload = (forgotPasswordResult): Common_User.ForgotPassword.forgotPasswordResult => {
  // TODO: Consider always returning an OK response, so we don't reveal details about an account's existance
  switch forgotPasswordResult {
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
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let forgotPassword: Common_User.ForgotPassword.forgotPassword = body
    let {client} = Server_Middleware.getRequestData(req)
    client
    ->Server_User.forgotPassword(forgotPassword)
    ->Promise.then(forgotPasswordResult => {
      let payload = makePayload(forgotPasswordResult)
      Server_Api.sendSuccess(res, payload)
      Promise.resolve()
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
