type reCaptchaResponse = {
  success: bool,
  @as("error-codes") errorCodes: option<array<string>>,
  @as("challenge_ts") challengeTs: option<string>, // ISO format yyyy-MM-dd'T'HH:mm:ssZZ
}

let makeUrl = (config: Server_Config.reCaptcha, token) => {
  "https://www.google.com/recaptcha/api/siteverify" ++
  "?secret=" ++
  Js.Global.encodeURIComponent(config.secretKey) ++
  "&response=" ++
  Js.Global.encodeURIComponent(token)
}

let verifyToken = (token: string): Promise.t<result<unit, unit>> => {
  let config: Server_Config.t = Server_Config.get()
  let url = makeUrl(config.reCaptcha, token)
  NodeFetch.postJson(url)->Promise.thenResolve((response: reCaptchaResponse) => {
    response.success ? Ok() : Error()
  })
}
