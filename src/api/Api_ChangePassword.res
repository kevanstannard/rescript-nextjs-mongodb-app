let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  let body = Server_Middleware.NextRequest.getBody(req)
  switch body {
  | None => {
      Server_Api.sendError(res, #ServerError, "Body is missing from request")
      Promise.resolve()
    }
  | Some(changePassword: Common_User.ChangePassword.changePassword) => {
      let {client, currentUserId} = Server_Middleware.getRequestData(req)
      switch currentUserId {
      | None => {
          Server_Api.sendError(res, #Forbidden, "Not logged in")
          Promise.resolve()
        }
      | Some(currentUserId) =>
        client
        ->Server_User.changePassword(currentUserId, changePassword)
        ->Promise.then(changePasswordResult => {
          let result: Common_User.ChangePassword.changePasswordResult = switch changePasswordResult {
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
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
