let makePayload = (resetPasswordResult): Common_User.ResetPassword.resetPasswordResult => {
  switch resetPasswordResult {
  | Ok() => {
      result: #Ok,
      errors: None,
    }
  | Error(errors) => {
      result: #Error,
      errors: Some(errors),
    }
  }
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let resetPassword: Common_User.ResetPassword.resetPassword = body
    let {client} = Server_Middleware.getRequestData(req)
    client
    ->Server_User.resetPassword(resetPassword)
    ->Promise.then(resetPasswordResult => {
      let payload = makePayload(resetPasswordResult)
      Server_Api.sendSuccess(res, payload)
      Promise.resolve()
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
