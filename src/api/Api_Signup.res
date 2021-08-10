let makePayload = (signupResult): Common_User.Signup.signupResult => {
  let errors = switch signupResult {
  | Ok() => Common_User.Signup.emptyErrors()
  | Error(errors) => errors
  }
  {errors: errors}
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let signup = Common_User.Signup.Codec.decode(body)
    switch signup {
    | Error(reason) => {
        Server_Api.sendError(res, #BadRequest, reason)
        Promise.resolve()
      }
    | Ok(signup) => {
        let {client} = Server_Middleware.getRequestData(req)
        client
        ->Server_User.signup(signup)
        ->Promise.then(signupResult => {
          let payload = makePayload(signupResult)
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
