let handleOK = (req, res, user: Server_User.User.t) => {
  let nextUrl = Server_Session.NextUrl.get(req)
  let userId = MongoDb.ObjectId.toString(user._id)
  Server_Session.UserId.set(req, Some(userId))->Promise.then(_ => {
    Server_Session.NextUrl.set(req, None)->Promise.then(_ => {
      let payload: Common_User.Login.loginResult = {
        nextUrl: nextUrl,
        errors: Common_User.Login.emptyErrors(),
      }
      Server_Api.sendSuccess(res, payload)
      Promise.resolve()
    })
  })
}

let handleError = (res, errors) => {
  let payload: Common_User.Login.loginResult = {
    errors: errors,
    nextUrl: None,
  }
  Server_Api.sendSuccess(res, payload)
  Promise.resolve()
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBodyAsJson(req, res, body => {
    let login = Common_User.Login.Codec.decode(body)
    switch login {
    | Error(reason) => {
        Server_Api.sendError(res, #BadRequest, reason)
        Promise.resolve()
      }
    | Ok(login) => {
        let {client} = Server_Middleware.getRequestData(req)
        client
        ->Server_User.login(login)
        ->Promise.then(loginResult => {
          switch loginResult {
          | Ok(user) => handleOK(req, res, user)
          | Error(errors) => handleError(res, errors)
          }
        })
      }
    }
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
