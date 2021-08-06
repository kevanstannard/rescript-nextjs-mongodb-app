// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Common_Url from "../../modules/common/Common_Url.mjs";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Link from "../../components/Component_Link.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";

function Page_Activate_View$ActivationSuccessful(Props) {
  var user = Props.user;
  return React.createElement("div", undefined, React.createElement(Component_Title.make, {
                  text: "Account activation successful",
                  size: "Primary"
                }), React.createElement("p", {
                  className: "mb-4"
                }, "Your account has been activated."), React.createElement("p", {
                  className: "mb-4"
                }, user !== undefined ? React.createElement(Component_Link.make, {
                        href: Common_Url.home(undefined),
                        children: "Return to home"
                      }) : React.createElement(Component_Link.make, {
                        href: Common_Url.login(undefined),
                        children: "Login to your account"
                      })));
}

var ActivationSuccessful = {
  make: Page_Activate_View$ActivationSuccessful
};

function Page_Activate_View$ActivationFailed(Props) {
  return React.createElement("div", undefined, React.createElement(Component_Title.make, {
                  text: "Account activation failed",
                  size: "Primary"
                }), React.createElement("p", {
                  className: "mb-4"
                }, "Sorry, there was a problem activating your account."), React.createElement("p", {
                  className: "mb-4"
                }, React.createElement(Component_Link.make, {
                      href: Common_Url.contact(undefined),
                      children: "Please contact us for support"
                    })));
}

var ActivationFailed = {
  make: Page_Activate_View$ActivationFailed
};

function Page_Activate_View(Props) {
  var user = Props.user;
  var activationSuccessful = Props.activationSuccessful;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: activationSuccessful ? React.createElement(Page_Activate_View$ActivationSuccessful, {
                      user: user
                    }) : React.createElement(Page_Activate_View$ActivationFailed, {})
            });
}

var Title;

var Link;

var make = Page_Activate_View;

export {
  Title ,
  Link ,
  ActivationSuccessful ,
  ActivationFailed ,
  make ,
  
}
/* react Not a pure module */
