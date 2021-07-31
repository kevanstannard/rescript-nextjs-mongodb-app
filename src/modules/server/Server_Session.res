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

let setUserId = (req: Next.Req.t, userId: option<string>): Promise.t<unit> => {
  switch userId {
  | None => unset(req, "userId")
  | Some(userId) => setString(req, "userId", userId)
  }
}

let getUserId = (req: Next.Req.t): option<string> => getString(req, "userId")->Js.Nullable.toOption

let setNextUrl = (req: Next.Req.t, nextUrl: option<string>): Promise.t<unit> => {
  switch nextUrl {
  | None => unset(req, "nextUrl")
  | Some(nextUrl) => setString(req, "nextUrl", nextUrl)
  }
}

let getNextUrl = (req: Next.Req.t): option<string> => {
  getString(req, "nextUrl")->Js.Nullable.toOption
}
