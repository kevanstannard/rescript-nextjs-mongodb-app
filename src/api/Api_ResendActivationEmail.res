let makePayload = (result): Common_User.ResendActivation.resendActivationResult => {
  let errors = switch result {
  | Ok() => Common_User.ResendActivation.emptyErrors()
  | Error(errors) => errors
  }
  {errors: errors}
}

let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  open Common_User.ResendActivation
  Server_Api.withBody(req, res, body => {
    let resendActivation: resendActivation = body
    let {client} = Server_Middleware.getRequestData(req)
    client
    ->Server_User.resendActivationEmail(resendActivation)
    ->Promise.then(result => {
      let payload = makePayload(result)
      Server_Api.sendSuccess(res, payload)
      Promise.resolve()
    })
  })
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
