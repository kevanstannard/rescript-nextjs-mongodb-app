let makePayload = (changePasswordResult): Common_User.ChangePassword.changePasswordResult => {
  let errors = switch changePasswordResult {
  | Ok() => Common_User.ChangePassword.emptyErrors()
  | Error(errors) => errors
  }
  {errors: errors}
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBodyAsJson(req, res, body => {
    Server_Api.withCurrentUser(req, res, currentUser => {
      let changePassword = Common_User.ChangePassword.Codec.decode(body)
      switch changePassword {
      | Error(reason) => {
          Server_Api.sendError(res, #BadRequest, reason)
          Promise.resolve()
        }
      | Ok(changePassword) => {
          let {client} = Server_Middleware.getRequestData(req)
          client
          ->Server_User.changePassword(currentUser._id, changePassword)
          ->Promise.then(changePasswordResult => {
            let payload = makePayload(changePasswordResult)
            Server_Api.sendSuccess(res, payload)
            Promise.resolve()
          })
        }
      }
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
