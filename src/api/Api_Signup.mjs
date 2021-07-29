// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Api from "../modules/server/Server_Api.mjs";
import * as Server_User from "../modules/server/Server_User.mjs";
import * as NextConnect from "next-connect";
import * as Server_Middleware from "../modules/server/Server_Middleware.mjs";

function handlePost(req, res) {
  var body = Server_Middleware.NextRequest.getBody(req);
  if (body !== undefined) {
    var match = Server_Middleware.getRequestData(req);
    return Server_User.signup(match.client, body).then(function (signupResult) {
                var match;
                match = signupResult.TAG === /* Ok */0 ? [
                    "Ok",
                    signupResult._0
                  ] : [
                    "Error",
                    signupResult._0
                  ];
                var result_result = match[0];
                var result_validation = match[1];
                var result = {
                  result: result_result,
                  validation: result_validation
                };
                Server_Api.sendJson(res, "Success", result);
                return Promise.resolve(undefined);
              });
  }
  Server_Api.sendError(res, "ServerError", "Body is missing from request");
  return Promise.resolve(undefined);
}

var $$default = NextConnect().use(Server_Middleware.all(undefined)).post(handlePost);

export {
  handlePost ,
  $$default ,
  $$default as default,
  
}
/* default Not a pure module */
