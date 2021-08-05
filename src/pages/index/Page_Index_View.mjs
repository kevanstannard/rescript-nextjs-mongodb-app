// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common_Url from "../../modules/common/Common_Url.mjs";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Link from "../../components/Component_Link.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";

function Page_Index_View(Props) {
  var user = Props.user;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: null
            }, React.createElement(Component_Title.make, {
                  text: "Hello",
                  size: "Primary"
                }), React.createElement("p", {
                  className: "mb-4"
                }, "This is an example application to demonstrate using ReScript MongoDB and NextJS together."), React.createElement("p", {
                  className: "mb-4"
                }, React.createElement(Component_Link.make, {
                      href: Common_Url.github(undefined),
                      children: "View the source code on Github"
                    })));
}

var Title;

var Link;

var make = Page_Index_View;

export {
  Title ,
  Link ,
  make ,
  
}
/* react Not a pure module */
