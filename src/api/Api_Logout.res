let handlePost = (req: Next.Req.t, res: Next.Res.t) => {
  Server_Session.destroy(req)
  let result: Common_User.Logout.logoutResult = {
    result: #Ok,
  }
  Server_Api.sendSuccess(res, result)
  Promise.resolve()
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.postAsync(handlePost)
