// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common_Url from "../../modules/common/Common_Url.mjs";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Link from "../../components/Component_Link.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";

function Page_ForgotPasswordSuccess_View(Props) {
  var user = Props.user;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: null
            }, React.createElement(Component_Title.make, {
                  text: "Forgot Password Successful",
                  size: "Primary"
                }), React.createElement("p", {
                  className: "mb-4"
                }, "We've sent you an email to reset your password."), React.createElement("p", {
                  className: "mb-4"
                }, React.createElement(Component_Link.make, {
                      href: Common_Url.home(undefined),
                      children: "Return to home"
                    })));
}

var Title;

var Link;

var make = Page_ForgotPasswordSuccess_View;

export {
  Title ,
  Link ,
  make ,
  
}
/* react Not a pure module */
