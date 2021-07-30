// Generated by ReScript, PLEASE EDIT WITH CARE

import Swr from "swr";
import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Common_Url from "../../modules/common/Common_Url.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Client_User from "../../modules/client/Client_User.mjs";
import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Client_Fetch from "../../modules/client/Client_Fetch.mjs";
import * as Page_Login_View from "./Page_Login_View.mjs";

function initialState(param) {
  return {
          email: "",
          password: "",
          validation: {
            email: undefined,
            password: undefined
          },
          isSubmitting: false,
          loginError: undefined
        };
}

function reducer(state, action) {
  switch (action.TAG | 0) {
    case /* SetEmail */0 :
        return {
                email: action._0,
                password: state.password,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                loginError: state.loginError
              };
    case /* SetPassword */1 :
        return {
                email: state.email,
                password: action._0,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                loginError: state.loginError
              };
    case /* SetIsSubmitting */2 :
        return {
                email: state.email,
                password: state.password,
                validation: state.validation,
                isSubmitting: action._0,
                loginError: state.loginError
              };
    case /* SetLoginError */3 :
        return {
                email: state.email,
                password: state.password,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                loginError: action._0
              };
    case /* SetValidation */4 :
        return {
                email: state.email,
                password: state.password,
                validation: action._0,
                isSubmitting: state.isSubmitting,
                loginError: state.loginError
              };
    
  }
}

function useCurrentUser(param) {
  var match = Swr("/api/user", Client_Fetch.getJson);
  return Caml_option.undefined_to_opt(match.data);
}

function renderPage(param) {
  var match = React.useReducer(reducer, {
        email: "",
        password: "",
        validation: {
          email: undefined,
          password: undefined
        },
        isSubmitting: false,
        loginError: undefined
      });
  var dispatch = match[1];
  var state = match[0];
  var onLoginClick = function (param) {
    var login_email = state.email;
    var login_password = state.password;
    var login = {
      email: login_email,
      password: login_password
    };
    var validation = Common_User.Login.validateLogin(login);
    Curry._1(dispatch, {
          TAG: /* SetLoginError */3,
          _0: undefined
        });
    Curry._1(dispatch, {
          TAG: /* SetValidation */4,
          _0: validation
        });
    if (!Common_User.Login.isValid(validation)) {
      return ;
    }
    Curry._1(dispatch, {
          TAG: /* SetIsSubmitting */2,
          _0: true
        });
    var onError = function (param) {
      Curry._1(dispatch, {
            TAG: /* SetLoginError */3,
            _0: "RequestFailed"
          });
      return Curry._1(dispatch, {
                  TAG: /* SetIsSubmitting */2,
                  _0: false
                });
    };
    var onSuccess = function (json) {
      var match = json.result;
      if (match === "Error") {
        Curry._1(dispatch, {
              TAG: /* SetValidation */4,
              _0: json.validation
            });
        Curry._1(dispatch, {
              TAG: /* SetLoginError */3,
              _0: undefined
            });
        return Curry._1(dispatch, {
                    TAG: /* SetIsSubmitting */2,
                    _0: false
                  });
      } else {
        document.location.assign(Common_Url.home(undefined));
        return ;
      }
    };
    Client_User.login(login, onSuccess, onError);
    
  };
  var loginError = Belt_Option.map(state.loginError, Common_User.Login.loginErrorToString);
  var emailError = Belt_Option.map(state.validation.email, Common_User.Login.emailErrorToString);
  var passwordError = Belt_Option.map(state.validation.password, Common_User.Login.passwordErrorToString);
  return React.createElement(Page_Login_View.make, {
              email: state.email,
              emailError: emailError,
              password: state.password,
              passwordError: passwordError,
              isSubmitting: state.isSubmitting,
              loginError: loginError,
              onEmailChange: (function (email) {
                  return Curry._1(dispatch, {
                              TAG: /* SetEmail */0,
                              _0: email
                            });
                }),
              onPasswordChange: (function (password) {
                  return Curry._1(dispatch, {
                              TAG: /* SetPassword */1,
                              _0: password
                            });
                }),
              onLoginClick: onLoginClick
            });
}

function $$default(param) {
  return renderPage(undefined);
}

export {
  initialState ,
  reducer ,
  useCurrentUser ,
  renderPage ,
  $$default ,
  $$default as default,
  
}
/* swr Not a pure module */
