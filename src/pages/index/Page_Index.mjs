// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Page_Index_View from "./Page_Index_View.mjs";

function $$default(props) {
  var user = Common_User.User.fromNullDto(props.userDto);
  return React.createElement(Page_Index_View.make, {
              user: user
            });
}

export {
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
