// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Js_exn from "rescript/lib/es6/js_exn.js";
import * as Server_Env from "./Server_Env.mjs";
import * as Caml_js_exceptions from "rescript/lib/es6/caml_js_exceptions.js";

function get(param) {
  try {
    var mongoDb_uri = Server_Env.getString("MONGODB_URI");
    var mongoDb_dbName = Server_Env.getString("MONGODB_DB_NAME");
    var mongoDb = {
      uri: mongoDb_uri,
      dbName: mongoDb_dbName
    };
    var config = {
      mongoDb: mongoDb
    };
    return {
            TAG: /* Ok */0,
            _0: config
          };
  }
  catch (raw_error){
    var error = Caml_js_exceptions.internalToOCamlException(raw_error);
    if (error.RE_EXN_ID !== Js_exn.$$Error) {
      return {
              TAG: /* Error */1,
              _0: "Unknown"
            };
    }
    var msg = error._1.message;
    if (msg !== undefined) {
      return {
              TAG: /* Error */1,
              _0: msg
            };
    } else {
      return {
              TAG: /* Error */1,
              _0: "Unkonwn"
            };
    }
  }
}

export {
  get ,
  
}
/* Server_Env Not a pure module */