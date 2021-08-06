let handleOK = (req, res, user: Server_User.User.t) => {
  let nextUrl = Server_Session.getNextUrl(req)
  let userId = MongoDb.ObjectId.toString(user._id)
  Server_Session.setUserId(req, Some(userId))->Promise.then(_ => {
    Server_Session.setNextUrl(req, None)->Promise.then(_ => {
      let payload: Common_User.Login.loginResult = {
        nextUrl: nextUrl,
        errors: {
          login: None,
          email: None,
          password: None,
        },
      }
      Server_Api.sendSuccess(res, payload->Common_Json.asJson)
      Promise.resolve()
    })
  })
}

let handleError = (res, reason) => {
  let error = switch reason {
  | #UserNotFound => #LoginFailed
  | #PasswordInvalid => #LoginFailed
  | #AccountInactive => #AccountInactive
  }
  let errors: Common_User.Login.errors = {
    login: Some(error),
    email: None,
    password: None,
  }
  let payload: Common_User.Login.loginResult = {
    errors: errors,
    nextUrl: None,
  }
  Server_Api.sendSuccess(res, payload->Common_Json.asJson)
  Promise.resolve()
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let login: Common_User.Login.login = body
    let {client} = Server_Middleware.getRequestData(req)
    client
    ->Server_User.login(login)
    ->Promise.then(loginResult => {
      switch loginResult {
      | Ok(user) => handleOK(req, res, user)
      | Error(reason) => handleError(res, reason)
      }
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
