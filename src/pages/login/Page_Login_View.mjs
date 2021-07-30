// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Component_Form from "../../components/Component_Form.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";
import * as Component_Button from "../../components/Component_Button.mjs";
import * as Component_AlertMessage from "../../components/Component_AlertMessage.mjs";

function Page_Login_View$ErrorMessage(Props) {
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
  make: Page_Login_View$ErrorMessage
};

function Page_Login_View(Props) {
  var email = Props.email;
  var emailError = Props.emailError;
  var password = Props.password;
  var passwordError = Props.passwordError;
  var isSubmitting = Props.isSubmitting;
  var loginError = Props.loginError;
  var onEmailChange = Props.onEmailChange;
  var onPasswordChange = Props.onPasswordChange;
  var onLoginClick = Props.onLoginClick;
  return React.createElement(Component_Form.FormContainer.make, {
              children: null
            }, React.createElement(Component_Title.make, {
                  text: "Login",
                  size: "Primary"
                }), React.createElement(Page_Login_View$ErrorMessage, {
                  error: loginError
                }), React.createElement(Component_Form.TextField.make, {
                  label: "Email",
                  value: email,
                  onChange: onEmailChange,
                  error: emailError
                }), React.createElement(Component_Form.PasswordField.make, {
                  label: "Password",
                  value: password,
                  onChange: onPasswordChange,
                  error: passwordError,
                  showPasswordStrength: false
                }), React.createElement(Component_Button.Button.make, {
                  state: isSubmitting ? "Processing" : "Ready",
                  onClick: onLoginClick,
                  color: "Green",
                  full: true,
                  children: "Login"
                }));
}

var Main;

var Title;

var AlertMessage;

var make = Page_Login_View;

export {
  Main ,
  Title ,
  AlertMessage ,
  ErrorMessage ,
  make ,
  
}
/* react Not a pure module */
