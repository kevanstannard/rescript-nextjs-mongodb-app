// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Server_Page from "../../modules/server/Server_Page.mjs";
import * as Server_Session from "../../modules/server/Server_Session.mjs";
import * as Server_Middleware from "../../modules/server/Server_Middleware.mjs";

function getServerSideProps(context) {
  var req = context.req;
  return Server_Middleware.runAll(req, context.res).then(function (param) {
              Server_Session.destroy(req);
              return Server_Page.redirectHome(undefined);
            });
}

export {
  getServerSideProps ,
  
}
/* Server_Middleware Not a pure module */
