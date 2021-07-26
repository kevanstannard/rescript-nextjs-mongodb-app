// Generated by ReScript, PLEASE EDIT WITH CARE

import * as NodeFetch from "../../bindings/NodeFetch.mjs";
import * as Server_Config from "./Server_Config.mjs";

function makeUrl(config, token) {
  return "https://www.google.com/recaptcha/api/siteverify?secret=" + encodeURIComponent(config.secretKey) + "&response=" + encodeURIComponent(token);
}

function verifyToken(token) {
  var config = Server_Config.get(undefined);
  var url = makeUrl(config.reCaptcha, token);
  return NodeFetch.postJson(url).then(function (response) {
              if (response.success) {
                return {
                        TAG: /* Ok */0,
                        _0: undefined
                      };
              } else {
                return {
                        TAG: /* Error */1,
                        _0: undefined
                      };
              }
            });
}

export {
  makeUrl ,
  verifyToken ,
  
}
/* NodeFetch Not a pure module */
