let makePayload = (forgotPasswordResult): Common_User.ForgotPassword.forgotPasswordResult => {
  // TODO: Consider always returning an OK response, so we don't reveal details about an account's existance
  let errors = switch forgotPasswordResult {
  | Ok() => Common_User.ForgotPassword.emptyErrors()
  | Error(errors) => errors
  }
  {errors: errors}
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let forgotPassword = Common_User.ForgotPassword.Codec.decode(body)
    switch forgotPassword {
    | Error(reason) => {
        Server_Api.sendError(res, #BadRequest, reason)
        Promise.resolve()
      }
    | Ok(forgotPassword) => {
        let {client} = Server_Middleware.getRequestData(req)
        client
        ->Server_User.forgotPassword(forgotPassword)
        ->Promise.then(forgotPasswordResult => {
          let payload = makePayload(forgotPasswordResult)
          Server_Api.sendSuccess(res, payload)
          Promise.resolve()
        })
      }
    }
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
