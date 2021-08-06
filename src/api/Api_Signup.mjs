// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Api from "../modules/server/Server_Api.mjs";
import * as Server_User from "../modules/server/Server_User.mjs";
import * as NextConnect from "next-connect";
import * as Server_Middleware from "../modules/server/Server_Middleware.mjs";

function makePayload(signupResult) {
  if (signupResult.TAG === /* Ok */0) {
    return {
            result: "Ok",
            validation: signupResult._0
          };
  } else {
    return {
            result: "Error",
            validation: signupResult._0
          };
  }
}

function handlePost(req, res) {
  return Server_Api.withBody(req, res, (function (body) {
                var match = Server_Middleware.getRequestData(req);
                return Server_User.signup(match.client, body).then(function (signupResult) {
                            var payload = makePayload(signupResult);
                            Server_Api.sendSuccess(res, payload);
                            return Promise.resolve(undefined);
                          });
              }));
}

var $$default = NextConnect().use(Server_Middleware.all(undefined)).post(handlePost);

export {
  makePayload ,
  handlePost ,
  $$default ,
  $$default as default,
  
}
/* default Not a pure module */
