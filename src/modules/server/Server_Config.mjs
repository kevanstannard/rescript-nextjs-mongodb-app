// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Env from "./Server_Env.mjs";

function get(param) {
  var mongoDb = {
    uri: Server_Env.getString("MONGODB_URI")
  };
  var session_cookiePassword = Server_Env.getString("SESSION_COOKIE_PASSWORD");
  var session_cookieName = Server_Env.getString("SESSION_COOKIE_NAME");
  var session = {
    cookiePassword: session_cookiePassword,
    cookieName: session_cookieName
  };
  var reCaptcha_secretKey = Server_Env.getString("RECAPTCHA_SECRET_KEY");
  var reCaptcha_siteKey = Server_Env.getString("RECAPTCHA_SITE_KEY");
  var reCaptcha = {
    secretKey: reCaptcha_secretKey,
    siteKey: reCaptcha_siteKey
  };
  return {
          mongoDb: mongoDb,
          session: session,
          reCaptcha: reCaptcha
        };
}

function getClientConfig(param) {
  var serverConfig = get(undefined);
  return {
          reCaptcha: {
            siteKey: serverConfig.reCaptcha.siteKey
          }
        };
}

export {
  get ,
  getClientConfig ,
  
}
/* Server_Env Not a pure module */
