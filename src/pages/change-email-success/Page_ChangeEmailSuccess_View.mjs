// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import Link from "next/link";
import * as Common_Url from "../../modules/common/Common_Url.mjs";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";

function Page_ChangeEmailSuccess_View(Props) {
  var user = Props.user;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: null
            }, React.createElement(Component_Title.make, {
                  text: "Change Email Confirmation",
                  size: "Primary"
                }), React.createElement("p", {
                  className: "mb-4"
                }, "We've sent you an email to confirm your new email address."), React.createElement("p", {
                  className: "mb-4"
                }, React.createElement(Link, {
                      href: Common_Url.home(undefined),
                      children: "Return to home"
                    })));
}

var Title;

var make = Page_ChangeEmailSuccess_View;

export {
  Title ,
  make ,
  
}
/* react Not a pure module */
