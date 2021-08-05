// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Page from "../../modules/server/Server_Page.mjs";
import * as Server_Middleware from "../../modules/server/Server_Middleware.mjs";

function makeResult(currentUser) {
  if (currentUser !== undefined) {
    return Server_Page.redirectHome(undefined);
  } else {
    return {
            props: {},
            redirect: undefined,
            notFound: undefined
          };
  }
}

function getServerSideProps(context) {
  var req = context.req;
  return Server_Middleware.runAll(req, context.res).then(function (param) {
              var match = Server_Middleware.getRequestData(req);
              return makeResult(match.currentUser);
            });
}

export {
  makeResult ,
  getServerSideProps ,
  
}
/* Server_Middleware Not a pure module */
