// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Page_ResetPasswordSuccess_View from "./Page_ResetPasswordSuccess_View.mjs";

function $$default(param) {
  var user = Belt_Option.map(Caml_option.null_to_opt(param.userDto), Common_User.User.fromDto);
  return React.createElement(Page_ResetPasswordSuccess_View.make, {
              user: user
            });
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
