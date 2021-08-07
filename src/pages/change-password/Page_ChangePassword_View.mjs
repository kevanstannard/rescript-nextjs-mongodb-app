// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Layout_Main from "../../layouts/Layout_Main.mjs";
import * as Component_Form from "../../components/Component_Form.mjs";
import * as Component_Title from "../../components/Component_Title.mjs";
import * as Component_Button from "../../components/Component_Button.mjs";
import * as Component_AlertMessage from "../../components/Component_AlertMessage.mjs";

function Page_ChangePassword_View$ErrorMessage(Props) {
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
  make: Page_ChangePassword_View$ErrorMessage
};

function Page_ChangePassword_View(Props) {
  var user = Props.user;
  var currentPassword = Props.currentPassword;
  var newPassword = Props.newPassword;
  var newPasswordConfirm = Props.newPasswordConfirm;
  var onCurrentPasswordChange = Props.onCurrentPasswordChange;
  var onNewPasswordChange = Props.onNewPasswordChange;
  var onNewPasswordConfirmChange = Props.onNewPasswordConfirmChange;
  var onChangePasswordClick = Props.onChangePasswordClick;
  var isSubmitting = Props.isSubmitting;
  var changePasswordError = Props.changePasswordError;
  var currentPasswordError = Props.currentPasswordError;
  var newPasswordError = Props.newPasswordError;
  var newPasswordConfirmError = Props.newPasswordConfirmError;
  return React.createElement(Layout_Main.make, {
              user: user,
              children: React.createElement(Component_Form.FormContainer.make, {
                    children: null
                  }, React.createElement(Component_Title.make, {
                        text: "Change Password",
                        size: "Primary"
                      }), React.createElement(Page_ChangePassword_View$ErrorMessage, {
                        error: changePasswordError
                      }), React.createElement(Component_Form.PasswordField.make, {
                        label: "Current password",
                        value: currentPassword,
                        onChange: onCurrentPasswordChange,
                        error: currentPasswordError,
                        showPasswordStrength: false
                      }), React.createElement(Component_Form.PasswordField.make, {
                        label: "New password",
                        value: newPassword,
                        onChange: onNewPasswordChange,
                        error: newPasswordError,
                        showPasswordStrength: true
                      }), React.createElement(Component_Form.PasswordField.make, {
                        label: "Confirm new password",
                        value: newPasswordConfirm,
                        onChange: onNewPasswordConfirmChange,
                        error: newPasswordConfirmError,
                        showPasswordStrength: false
                      }), React.createElement("div", {
                        className: "mb-6"
                      }, React.createElement(Component_Button.Button.make, {
                            state: isSubmitting ? "Processing" : "Ready",
                            onClick: onChangePasswordClick,
                            color: "Green",
                            full: true,
                            children: "Change Password"
                          })))
            });
}

var Title;

var AlertMessage;

var make = Page_ChangePassword_View;

export {
  Title ,
  AlertMessage ,
  ErrorMessage ,
  make ,
  
}
/* react Not a pure module */
