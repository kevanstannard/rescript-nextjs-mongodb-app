// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Page_ForgotPasswordSuccess_View from "./Page_ForgotPasswordSuccess_View.mjs";

function $$default(param) {
  var user = Common_User.User.fromNullDto(param.userDto);
  return React.createElement(Page_ForgotPasswordSuccess_View.make, {
              user: user
            });
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
