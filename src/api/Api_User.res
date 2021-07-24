let handleGet = (_req: Next.Req.t, res: Next.Res.t) => {
  Server_Api.sendJson(res, #Success, {"id": 0})
  Promise.resolve()
}

let default =
  NextConnect.nc()
  ->NextConnect.useHandlerAsync(Server_Middleware.all())
  ->NextConnect.getAsync(handleGet)
