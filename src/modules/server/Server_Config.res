type mongoDb = {uri: string}

type session = {
  cookiePassword: string,
  cookieName: string,
}

type reCaptcha = {
  secretKey: string,
  siteKey: string,
}

type sendGrid = {apiKey: string}

type system = {
  emailName: string,
  emailAddress: string,
}

type t = {
  mongoDb: mongoDb,
  session: session,
  reCaptcha: reCaptcha,
  sendGrid: sendGrid,
  system: system,
}

let get = (): t => {
  let mongoDb: mongoDb = {
    uri: Server_Env.getString("MONGODB_URI"),
  }
  let session: session = {
    cookiePassword: Server_Env.getString("SESSION_COOKIE_PASSWORD"),
    cookieName: Server_Env.getString("SESSION_COOKIE_NAME"),
  }
  let reCaptcha: reCaptcha = {
    siteKey: Server_Env.getString("RECAPTCHA_SITE_KEY"),
    secretKey: Server_Env.getString("RECAPTCHA_SECRET_KEY"),
  }
  let sendGrid: sendGrid = {
    apiKey: Server_Env.getString("SENDGRID_API_KEY"),
  }
  let system: system = {
    emailName: Server_Env.getString("SYSTEM_EMAIL_NAME"),
    emailAddress: Server_Env.getString("SYSTEM_EMAIL_ADDRESS"),
  }
  let config = {
    mongoDb: mongoDb,
    session: session,
    reCaptcha: reCaptcha,
    sendGrid: sendGrid,
    system: system,
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
