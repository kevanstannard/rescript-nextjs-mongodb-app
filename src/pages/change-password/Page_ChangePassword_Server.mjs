// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Server_User from "../../modules/server/Server_User.mjs";
import * as Server_Middleware from "../../modules/server/Server_Middleware.mjs";

function makeResult(user) {
  var props = {
    user: user
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
              var commonUser = Belt_Option.map(match.currentUser, Server_User.toCommonUserDto);
              return makeResult(commonUser !== undefined ? commonUser : null);
            });
}

export {
  makeResult ,
  getServerSideProps ,
  
}
/* Server_User Not a pure module */
