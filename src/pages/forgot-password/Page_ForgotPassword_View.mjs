// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Form from "../../components/Component_Form.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";
import * as Component_Button from "../../components/Component_Button.mjs";
import * as Component_AlertMessage from "../../components/Component_AlertMessage.mjs";

function Page_ForgotPassword_View$ErrorMessage(Props) {
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
  make: Page_ForgotPassword_View$ErrorMessage
};

function Page_ForgotPassword_View(Props) {
  var user = Props.user;
  var forgotPasswordError = Props.forgotPasswordError;
  var email = Props.email;
  var emailError = Props.emailError;
  var isSubmitting = Props.isSubmitting;
  var onEmailChange = Props.onEmailChange;
  var onForgotPasswordClick = Props.onForgotPasswordClick;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: React.createElement(Component_Form.FormContainer.make, {
                    children: null
                  }, React.createElement(Component_Title.make, {
                        text: "Forgot Password",
                        size: "Primary"
                      }), React.createElement(Page_ForgotPassword_View$ErrorMessage, {
                        error: forgotPasswordError
                      }), React.createElement(Component_Form.EmailField.make, {
                        label: "Email address of your account",
                        value: email,
                        onChange: onEmailChange,
                        error: emailError
                      }), React.createElement("div", {
                        className: "mb-6"
                      }, React.createElement(Component_Button.Button.make, {
                            state: isSubmitting ? "Processing" : "Ready",
                            onClick: onForgotPasswordClick,
                            color: "Green",
                            full: true,
                            children: "Forgot Password"
                          })))
            });
}

var Title;

var AlertMessage;

var make = Page_ForgotPassword_View;

export {
  Title ,
  AlertMessage ,
  ErrorMessage ,
  make ,
  
}
/* react Not a pure module */
