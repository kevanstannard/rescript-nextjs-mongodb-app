let handleError = (res, error) => {
  let payload: Common_User.ResendActivation.resendActivationResult = {error: error}
  Server_Api.sendSuccess(res, payload)
  Promise.resolve()
}

let handleOk = (req, res, resendActivation) => {
  let {client} = Server_Middleware.getRequestData(req)
  client
  ->Server_User.resendActivationEmail(resendActivation)
  ->Promise.then(result => {
    let payload: Common_User.ResendActivation.resendActivationResult = switch result {
    | Ok() => {error: None}
    | Error(resendActivationError) => {error: Some(resendActivationError)}
    }
    Server_Api.sendSuccess(res, payload)
    Promise.resolve()
  })
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  open Common_User.ResendActivation
  Server_Api.withBody(req, res, body => {
    let resendActivation: resendActivation = body
    let error = validateResendActivation(resendActivation)
    if isError(error) {
      handleError(res, error)
    } else {
      handleOk(req, res, resendActivation)
    }
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
