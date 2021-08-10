let makePayload = (resetPasswordResult): Common_User.ResetPassword.resetPasswordResult => {
  let errors = switch resetPasswordResult {
  | Ok() => Common_User.ResetPassword.emptyErrors()
  | Error(errors) => errors
  }
  {errors: errors}
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let resetPassword = Common_User.ResetPassword.Codec.decode(body)
    switch resetPassword {
    | Error(reason) => {
        Server_Api.sendError(res, #BadRequest, reason)
        Promise.resolve()
      }
    | Ok(resetPassword) => {
        let {client} = Server_Middleware.getRequestData(req)
        client
        ->Server_User.resetPassword(resetPassword)
        ->Promise.then(resetPasswordResult => {
          let payload = makePayload(resetPasswordResult)
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
