// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Page_ChangePasswordSuccess_View from "./Page_ChangePasswordSuccess_View.mjs";

function $$default(param) {
  var user = Common_User.User.fromDto(param.userDto);
  return React.createElement(Page_ChangePasswordSuccess_View.make, {
              user: user
            });
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
