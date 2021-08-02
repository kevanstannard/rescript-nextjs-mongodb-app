let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(signup: Common_User.Signup.signup) => {
      let {client} = Server_Middleware.getRequestData(req)
      client
      ->Server_User.signup(signup)
      ->Promise.then(signupResult => {
        let result: Common_User.Signup.signupResult = switch signupResult {
        | Ok(validation) => {
            result: #Ok,
            validation: validation,
          }
        | Error(validation) => {
            result: #Error,
            validation: validation,
          }
        }
        Server_Api.sendJson(res, #Success, result->Common_Json.asJson)
        Promise.resolve()
      })
    }
  }
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)