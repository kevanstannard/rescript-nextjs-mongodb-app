let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(changeEmail: Common_User.ChangeEmail.changeEmail) => {
      let {client, currentUserId} = Server_Middleware.getRequestData(req)
      switch currentUserId {
      | None => {
          Server_Api.sendError(res, #Forbidden, "Not logged in")
          Promise.resolve()
        }
      | Some(currentUserId) =>
        client
        ->Server_User.changeEmail(currentUserId, changeEmail)
        ->Promise.then(changeEmailResult => {
          let result: Common_User.ChangeEmail.changeEmailResult = switch changeEmailResult {
          | Ok(errors) => {
              result: #Ok,
              errors: errors,
            }
          | Error(errors) => {
              result: #Error,
              errors: errors,
            }
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
