let getSession = NextIronSession.getSession

let getString = NextIronSession.getString

let destroy = NextIronSession.destroy

let setString = (req, key, value) => {
  NextIronSession.setString(req, key, value)
  NextIronSession.save(req)
}

let unset = (req, key) => {
  NextIronSession.unset(req, key)
  NextIronSession.save(req)
}

module UserId = {
  let key = "userId"

  let set = (req: Next.Req.t, userId: option<string>): Promise.t<unit> => {
    switch userId {
    | None => unset(req, key)
    | Some(userId) => setString(req, key, userId)
    }
  }

  let get = (req: Next.Req.t): option<string> => getString(req, key)->Js.Nullable.toOption
}

module NextUrl = {
  let key = "nextUrl"

  let set = (req: Next.Req.t, nextUrl: option<string>): Promise.t<unit> => {
    switch nextUrl {
    | None => unset(req, key)
    | Some(nextUrl) => setString(req, key, nextUrl)
    }
  }

  let get = (req: Next.Req.t): option<string> => {
    getString(req, key)->Js.Nullable.toOption
  }
}
