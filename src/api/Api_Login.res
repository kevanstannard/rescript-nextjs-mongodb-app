let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(login: Common_User.Login.login) => {
      let {client} = Server_Middleware.getRequestData(req)
      client
      ->Server_User.login(login)
      ->Promise.then(loginResult => {
        switch loginResult {
        | Ok(user) => {
            let nextUrl = Server_Session.getNextUrl(req)
            let userId = MongoDb.ObjectId.toString(user._id)
            Server_Session.setUserId(req, Some(userId))->Promise.then(_ => {
              Server_Session.setNextUrl(req, None)->Promise.then(_ => {
                let result: Common_User.Login.loginResult = {
                  nextUrl: nextUrl,
                  errors: {
                    login: None,
                    email: None,
                    password: None,
                  },
                }
                Server_Api.sendJson(res, #Success, result->Common_Json.asJson)
                Promise.resolve()
              })
            })
          }
        | Error(reason) =>
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
          let result: Common_User.Login.loginResult = {
            errors: errors,
            nextUrl: None,
          }
          Server_Api.sendJson(res, #Success, result->Common_Json.asJson)
          Promise.resolve()
        }
      })
    }
  }
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
