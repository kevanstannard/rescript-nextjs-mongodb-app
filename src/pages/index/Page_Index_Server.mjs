// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Env from "../../modules/server/Server_Env.mjs";

function makeResult(param) {
  var props = {
    env: Server_Env.getString("NODE_ENV")
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
