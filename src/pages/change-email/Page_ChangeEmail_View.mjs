// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Form from "../../components/Component_Form.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";
import * as Component_Button from "../../components/Component_Button.mjs";
import * as Component_AlertMessage from "../../components/Component_AlertMessage.mjs";

function Page_ChangeEmail_View$ErrorMessage(Props) {
  var error = Props.error;
  if (error !== undefined) {
    return React.createElement(Component_AlertMessage.make, {
                type_: "Error",
                children: error
              });
  } else {
    return null;
  }
}

var ErrorMessage = {
  make: Page_ChangeEmail_View$ErrorMessage
};

function Page_ChangeEmail_View(Props) {
  var user = Props.user;
  var email = Props.email;
  var onEmailChange = Props.onEmailChange;
  var onChangeEmailClick = Props.onChangeEmailClick;
  var isSubmitting = Props.isSubmitting;
  var changeEmailError = Props.changeEmailError;
  var emailError = Props.emailError;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: React.createElement(Component_Form.FormContainer.make, {
                    children: null
                  }, React.createElement(Component_Title.make, {
                        text: "Change Email",
                        size: "Primary"
                      }), React.createElement(Page_ChangeEmail_View$ErrorMessage, {
                        error: changeEmailError
                      }), React.createElement(Component_Form.TextField.make, {
                        label: "New email address",
                        value: email,
                        onChange: onEmailChange,
                        error: emailError
                      }), React.createElement(Component_Button.Button.make, {
                        state: isSubmitting ? "Processing" : "Ready",
                        onClick: onChangeEmailClick,
                        color: "Green",
                        full: true,
                        children: "Change Email"
                      }))
            });
}

var Title;

var AlertMessage;

var make = Page_ChangeEmail_View;

export {
  Title ,
  AlertMessage ,
  ErrorMessage ,
  make ,
  
}
/* react Not a pure module */