let makePayload = (changeEmailResult): Common_User.ChangeEmail.changeEmailResult => {
  let errors = switch changeEmailResult {
  | Ok(errors) => errors
  | Error(errors) => errors
  }
  {
    errors: errors,
  }
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    Server_Api.withCurrentUser(req, res, currentUser => {
      let changeEmail: Common_User.ChangeEmail.changeEmail = body
      let {client} = Server_Middleware.getRequestData(req)
      client
      ->Server_User.changeEmail(currentUser._id, changeEmail)
      ->Promise.then(changeEmailResult => {
        let payload = makePayload(changeEmailResult)
        Server_Api.sendSuccess(res, payload)
        Promise.resolve()
      })
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
