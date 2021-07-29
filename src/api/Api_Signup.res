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
        let (result, validation) = switch signupResult {
        | Ok(validation) => (#Ok, validation)
        | Error(validation) => (#Error, validation)
        }
        let result: Common_User.Signup.signupResult = {
          result: result,
          validation: validation,
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
