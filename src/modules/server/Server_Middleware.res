// Default Next.js middleware helpers
module NextRequest = {
  let getBody = (req: Next.Req.t) => {
    req->Next.Req.body->Js.Nullable.toOption
  }
}

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

module Session = {
  let middlewareAsync = (
    (),
    req: Next.Req.t,
    res: Next.Res.t,
    next: unit => Promise.t<unit>,
  ): Promise.t<unit> => {
    let config = Server_Config.get()
    let options: NextIronSession.options = {
      password: config.session.cookiePassword,
      cookieName: config.session.cookieName,
      cookieOptions: {
        secure: Server_NodeEnv.isProduction(),
      },
    }
    NextIronSession.applySession(req, res, options)->Promise.then(next)
  }
}

module User = {
  let userKey = "user"

  let setUser = (req: Next.Req.t, value: option<Server_User.User.t>): unit =>
    Server_Request.set(req, userKey, value)

  let getUser = (req: Next.Req.t): option<Server_User.User.t> => Server_Request.get(req, userKey)

  let middlewareAsync = (
    (),
    req: Next.Req.t,
    _res: Next.Res.t,
    next: unit => Promise.t<unit>,
  ): Promise.t<unit> => {
    let userId: option<string> = Server_Session.UserId.get(req)
    switch userId {
    | None => {
        setUser(req, None)
        Promise.resolve()
      }
    | Some(userId) => {
        let userId = MongoDb.ObjectId.fromString(userId)
        switch userId {
        | Error(_) => Promise.resolve()
        | Ok(userId) =>
          Mongo.getClient(req)
          ->Server_User.findUserByObjectId(userId)
          ->Promise.then(user => {
            setUser(req, user)
            Promise.resolve()
          })
        }
      }
    }->Promise.then(next)
  }
}

let all = () => {
  NextConnect.nc()
  ->NextConnect.useMiddlewareAsync(Mongo.middlewareAsync())
  ->NextConnect.useMiddlewareAsync(Session.middlewareAsync())
  ->NextConnect.useMiddlewareAsync(User.middlewareAsync())
}

let run = NextConnect.run

let runAll = (req: Next.Req.t, res: Next.Res.t) => all()->run(req, res)

type requestData = {
  client: MongoDb.MongoClient.t,
  currentUser: option<Server_User.User.t>,
}

let getRequestData = req => {
  let client = Mongo.getClient(req)
  let user = User.getUser(req)
  let requestData: requestData = {
    client: client,
    currentUser: user,
  }
  requestData
}
