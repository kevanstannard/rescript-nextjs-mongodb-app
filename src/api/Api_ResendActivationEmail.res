let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  open Common_User.ResendActivation
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(resendActivation: resendActivation) => {
      let error = validateResendActivation(resendActivation)
      if isError(error) {
        let result: resendActivationResult = {error: error}
        Server_Api.sendJson(res, #Success, result->Common_Json.asJson)
        Promise.resolve()
      } else {
        let {client} = Server_Middleware.getRequestData(req)
        client
        ->Server_User.resendActivationEmail(resendActivation)
        ->Promise.then(result => {
          let result: resendActivationResult = switch result {
          | Ok() => {error: None}
          | Error(resendActivationError) => {error: Some(resendActivationError)}
          }
          Server_Api.sendJson(res, #Success, result->Common_Json.asJson)
          Promise.resolve()
        })
      }
    }
  }
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
