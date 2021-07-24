module Mongo = {
  type t = MongoDb.MongoClient.t
  let key = "mongodb"
  let setClient = (req: Next.Req.t, value: t): unit => Next.Req.set(req, key, value)
  let getClient = (req: Next.Req.t): t => Next.Req.get_UNSAFE(req, key)
  let middlewareAsync = (
    (),
    req: Next.Req.t,
    _res: Next.Res.t,
    next: unit => Promise.t<unit>,
  ): Promise.t<unit> => {
    let config = Server_Config.get()
    Server_Mongo.connect(config.mongoDb)
    ->Promise.then(client => {
      setClient(req, client)
      Promise.resolve()
    })
    ->Promise.then(next)
  }
}

let all = () => {
  NextConnect.nc()->NextConnect.useMiddlewareAsync(Mongo.middlewareAsync())
}

let run = NextConnect.run

type requestData = {client: MongoDb.MongoClient.t}

let getRequestData = req => {
  let client = Mongo.getClient(req)
  let requestData: requestData = {
    client: client,
  }
  requestData
}
