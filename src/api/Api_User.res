let handleGet = (_req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.sendJson(res, #Success, {"id": 0})
  Promise.resolve()

  // let {client} = Server_Middleware.getRequestData(req)
  // let signup: Common_User.Signup.signup = {
  //   email: "hello@example.com",
  //   password: "abc123",
  //   reCaptcha: None,
  // }

  // Js.log(signup)

  // client
  // ->Server_User.signupUser(signup)
  // ->Promise.then(dbUser => {
  //   Js.log(dbUser)

  //   Server_Api.sendJson(res, #Success, {"id": 0})
  //   Promise.resolve()
  // })
  // ->Promise.catch(error => {
  //   Js.log(error)
  //   Js.Exn.raiseError("Error")
  // })
}

// let default =
//   NextConnect.nc()
//   ->NextConnect.useHandlerAsync(Server_Middleware.all())
//   ->NextConnect.getAsync(handleGet)

let default = NextConnect.nc()->NextConnect.getAsync(handleGet)
