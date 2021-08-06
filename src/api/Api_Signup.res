let makePayload = (signupResult): Common_User.Signup.signupResult => {
  let errors = switch signupResult {
  | Ok() => Common_User.Signup.emptyErrors()
  | Error(errors) => errors
  }
  {errors: errors}
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.withBody(req, res, body => {
    let signup: Common_User.Signup.signup = body
    let {client} = Server_Middleware.getRequestData(req)
    client
    ->Server_User.signup(signup)
    ->Promise.then(signupResult => {
      let payload = makePayload(signupResult)
      Server_Api.sendSuccess(res, payload)
      Promise.resolve()
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
