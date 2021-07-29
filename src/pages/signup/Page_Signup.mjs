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
import * as Page_Signup_View from "./Page_Signup_View.mjs";

function initialState(param) {
  return {
          email: "",
          password: "",
          reCaptcha: undefined,
          validation: {
            email: undefined,
            password: undefined,
            reCaptcha: undefined
          },
          isSubmitting: false,
          signupError: undefined,
          signupAttemptCount: 0
        };
}

function reducer(state, action) {
  if (typeof action === "number") {
    return {
            email: state.email,
            password: state.password,
            reCaptcha: state.reCaptcha,
            validation: state.validation,
            isSubmitting: state.isSubmitting,
            signupError: state.signupError,
            signupAttemptCount: state.signupAttemptCount + 1 | 0
          };
  }
  switch (action.TAG | 0) {
    case /* SetEmail */0 :
        return {
                email: action._0,
                password: state.password,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                signupError: state.signupError,
                signupAttemptCount: state.signupAttemptCount
              };
    case /* SetPassword */1 :
        return {
                email: state.email,
                password: action._0,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                signupError: state.signupError,
                signupAttemptCount: state.signupAttemptCount
              };
    case /* SetReCaptcha */2 :
        return {
                email: state.email,
                password: state.password,
                reCaptcha: action._0,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                signupError: state.signupError,
                signupAttemptCount: state.signupAttemptCount
              };
    case /* SetIsSubmitting */3 :
        return {
                email: state.email,
                password: state.password,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: action._0,
                signupError: state.signupError,
                signupAttemptCount: state.signupAttemptCount
              };
    case /* SetSignupError */4 :
        return {
                email: state.email,
                password: state.password,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                signupError: action._0,
                signupAttemptCount: state.signupAttemptCount
              };
    case /* SetValidation */5 :
        return {
                email: state.email,
                password: state.password,
                reCaptcha: state.reCaptcha,
                validation: action._0,
                isSubmitting: state.isSubmitting,
                signupError: state.signupError,
                signupAttemptCount: state.signupAttemptCount
              };
    
  }
}

function useCurrentUser(param) {
  var match = Swr("/api/user", Client_Fetch.getJson);
  return Caml_option.undefined_to_opt(match.data);
}

function renderPage(config) {
  var match = React.useReducer(reducer, {
        email: "",
        password: "",
        reCaptcha: undefined,
        validation: {
          email: undefined,
          password: undefined,
          reCaptcha: undefined
        },
        isSubmitting: false,
        signupError: undefined,
        signupAttemptCount: 0
      });
  var dispatch = match[1];
  var state = match[0];
  var onSignupClick = function (param) {
    var signup_email = state.email;
    var signup_password = state.password;
    var signup_reCaptcha = state.reCaptcha;
    var signup = {
      email: signup_email,
      password: signup_password,
      reCaptcha: signup_reCaptcha
    };
    var validation = Common_User.Signup.validateSignup(signup);
    Curry._1(dispatch, {
          TAG: /* SetSignupError */4,
          _0: undefined
        });
    Curry._1(dispatch, {
          TAG: /* SetValidation */5,
          _0: validation
        });
    if (!Common_User.Signup.isValid(validation)) {
      return ;
    }
    Curry._1(dispatch, {
          TAG: /* SetIsSubmitting */3,
          _0: true
        });
    var onError = function (param) {
      Curry._1(dispatch, {
            TAG: /* SetSignupError */4,
            _0: "RequestFailed"
          });
      return Curry._1(dispatch, {
                  TAG: /* SetIsSubmitting */3,
                  _0: false
                });
    };
    var onSuccess = function (json) {
      var match = json.result;
      if (match === "Error") {
        Curry._1(dispatch, {
              TAG: /* SetValidation */5,
              _0: json.validation
            });
        Curry._1(dispatch, {
              TAG: /* SetSignupError */4,
              _0: undefined
            });
        Curry._1(dispatch, {
              TAG: /* SetIsSubmitting */3,
              _0: false
            });
        return Curry._1(dispatch, /* IncrementSignupAttemptCount */0);
      } else {
        document.location.assign(Common_Url.home(undefined));
        return ;
      }
    };
    Client_User.signup(signup, onSuccess, onError);
    
  };
  var signupError = Belt_Option.map(state.signupError, Common_User.Signup.signupErrorToString);
  var emailError = Belt_Option.map(state.validation.email, Common_User.Signup.emailErrorToString);
  var passwordError = Belt_Option.map(state.validation.password, Common_User.Signup.passwordErrorToString);
  var reCaptchaError = Belt_Option.map(state.validation.reCaptcha, Common_User.Signup.reCaptchaErrorToString);
  return React.createElement(Page_Signup_View.make, {
              reCaptchaSiteKey: config.reCaptcha.siteKey,
              email: state.email,
              emailError: emailError,
              password: state.password,
              passwordError: passwordError,
              reCaptchaError: reCaptchaError,
              isSubmitting: state.isSubmitting,
              signupError: signupError,
              signupAttemptCount: state.signupAttemptCount,
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
              onReCaptchaChange: (function (password) {
                  return Curry._1(dispatch, {
                              TAG: /* SetReCaptcha */2,
                              _0: password
                            });
                }),
              onSignupClick: onSignupClick
            });
}

function $$default(param) {
  return renderPage(param.config);
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
