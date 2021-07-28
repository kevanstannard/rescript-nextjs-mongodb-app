// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Env from "../../modules/server/Server_Env.mjs";
import * as Server_Config from "../../modules/server/Server_Config.mjs";

function makeResult(param) {
  var props_env = Server_Env.getNodeEnv(undefined);
  var props_config = Server_Config.getClientConfig(undefined);
  var props = {
    env: props_env,
    config: props_config
  };
  return {
          props: props,
          redirect: undefined,
          notFound: undefined
        };
}

function getServerSideProps(_context) {
  return Promise.resolve(makeResult(undefined));
}

export {
  makeResult ,
  getServerSideProps ,
  
}
/* Server_Env Not a pure module */
