// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Env from "../../modules/server/Server_Env.mjs";
import * as Server_Test from "../../modules/server/Server_Test.mjs";
import * as Server_Middleware from "../../modules/server/Server_Middleware.mjs";

function makeResult(count) {
  var props_env = Server_Env.getString("NODE_ENV");
  var props = {
    env: props_env,
    connected: true,
    count: count
  };
  return {
          props: props,
          redirect: undefined,
          notFound: undefined
        };
}

function getServerSideProps(context) {
  var req = context.req;
  return Server_Middleware.run(Server_Middleware.all(undefined), req, context.res).then(function (param) {
              var match = Server_Middleware.getRequestData(req);
              return Server_Test.getStats(match.client).then(function (stats) {
                          return Promise.resolve(makeResult(stats.count));
                        });
            });
}

export {
  makeResult ,
  getServerSideProps ,
  
}
/* Server_Env Not a pure module */
