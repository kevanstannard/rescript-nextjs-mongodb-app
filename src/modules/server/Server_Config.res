type mongoDb = {uri: string}

type reCaptcha = {
  secretKey: string,
  siteKey: string,
}

type t = {
  mongoDb: mongoDb,
  reCaptcha: reCaptcha,
}

let get = (): t => {
  let mongoDb: mongoDb = {
    uri: Server_Env.getString("MONGODB_URI"),
  }
  let reCaptcha: reCaptcha = {
    siteKey: Server_Env.getString("RECAPTCHA_SITE_KEY"),
    secretKey: Server_Env.getString("RECAPTCHA_SECRET_KEY"),
  }
  let config = {
    mongoDb: mongoDb,
    reCaptcha: reCaptcha,
  }
  config
}

let getClientConfig = (): Common_ClientConfig.t => {
  let serverConfig = get()
  let clientConfig: Common_ClientConfig.t = {
    reCaptcha: {
      siteKey: serverConfig.reCaptcha.siteKey,
    },
  }
  clientConfig
}
