// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Server_Mongo from "./Server_Mongo.mjs";
import * as NextConnect from "next-connect";
import * as Server_Config from "./Server_Config.mjs";

var key = "mongodb";

function setClient(req, value) {
  req[key] = value;
  
}

function getClient(req) {
  return req[key];
}

function middlewareAsync(param, req, _res, next) {
  var config = Server_Config.get(undefined);
  return Server_Mongo.connect(config.mongoDb).then(function (client) {
                setClient(req, client);
                return Promise.resolve(undefined);
              }).then(Curry.__1(next));
}

var Mongo = {
  key: key,
  setClient: setClient,
  getClient: getClient,
  middlewareAsync: middlewareAsync
};

function all(param) {
  return NextConnect().use(function (param, param$1, param$2) {
              return middlewareAsync(undefined, param, param$1, param$2);
            });
}

function run(prim0, prim1, prim2) {
  return prim0.run(prim1, prim2);
}

function getRequestData(req) {
  var client = req[key];
  return {
          client: client
        };
}

export {
  Mongo ,
  all ,
  run ,
  getRequestData ,
  
}
/* Server_Mongo Not a pure module */
