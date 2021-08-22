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

  let getRequestUrl = req => {
    // When navigating using <Next.Link />, for some reason here we see
    // requests with URLs starting with `/_next`. We don't want to store
    // these URLs for redirecting to on the next login, so we detect them here.
    let url = Next.Req.url(req)
    if Js.String2.startsWith(url, "/_next/") {
      None
    } else {
      Some(url)
    }
  }

  let set = (req: Next.Req.t): Promise.t<unit> => {
    let nextUrl = getRequestUrl(req)
    switch nextUrl {
    | None => unset(req, key)
    | Some(nextUrl) => setString(req, key, nextUrl)
    }
  }

  let clear = (req: Next.Req.t): Promise.t<unit> => {
    unset(req, key)
  }

  let get = (req: Next.Req.t): option<string> => {
    getString(req, key)->Js.Nullable.toOption
  }
}
