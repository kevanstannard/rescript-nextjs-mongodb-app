// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Common_Url from "../../modules/common/Common_Url.mjs";
import * as Belt_Option from "rescript/lib/es6/belt_Option.js";
import * as Caml_option from "rescript/lib/es6/caml_option.js";
import * as Client_User from "../../modules/client/Client_User.mjs";
import * as Common_User from "../../modules/common/Common_User.mjs";
import * as Router from "next/router";
import * as Common_Contact from "../../modules/common/Common_Contact.mjs";
import * as Page_Contact_View from "./Page_Contact_View.mjs";

function initialState(param) {
  return {
          name: "",
          email: "",
          message: "",
          reCaptcha: undefined,
          validation: {
            name: undefined,
            email: undefined,
            message: undefined,
            reCaptcha: undefined
          },
          isSubmitting: false,
          contactError: undefined,
          contactAttemptCount: 0
        };
}

function reducer(state, action) {
  if (typeof action === "number") {
    return {
            name: state.name,
            email: state.email,
            message: state.message,
            reCaptcha: state.reCaptcha,
            validation: state.validation,
            isSubmitting: state.isSubmitting,
            contactError: state.contactError,
            contactAttemptCount: state.contactAttemptCount + 1 | 0
          };
  }
  switch (action.TAG | 0) {
    case /* SetName */0 :
        return {
                name: action._0,
                email: state.email,
                message: state.message,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                contactError: state.contactError,
                contactAttemptCount: state.contactAttemptCount
              };
    case /* SetEmail */1 :
        return {
                name: state.name,
                email: action._0,
                message: state.message,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                contactError: state.contactError,
                contactAttemptCount: state.contactAttemptCount
              };
    case /* SetMessage */2 :
        return {
                name: state.name,
                email: state.email,
                message: action._0,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                contactError: state.contactError,
                contactAttemptCount: state.contactAttemptCount
              };
    case /* SetReCaptcha */3 :
        return {
                name: state.name,
                email: state.email,
                message: state.message,
                reCaptcha: action._0,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                contactError: state.contactError,
                contactAttemptCount: state.contactAttemptCount
              };
    case /* SetIsSubmitting */4 :
        return {
                name: state.name,
                email: state.email,
                message: state.message,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: action._0,
                contactError: state.contactError,
                contactAttemptCount: state.contactAttemptCount
              };
    case /* SetContactError */5 :
        return {
                name: state.name,
                email: state.email,
                message: state.message,
                reCaptcha: state.reCaptcha,
                validation: state.validation,
                isSubmitting: state.isSubmitting,
                contactError: action._0,
                contactAttemptCount: state.contactAttemptCount
              };
    case /* SetValidation */6 :
        return {
                name: state.name,
                email: state.email,
                message: state.message,
                reCaptcha: state.reCaptcha,
                validation: action._0,
                isSubmitting: state.isSubmitting,
                contactError: state.contactError,
                contactAttemptCount: state.contactAttemptCount
              };
    
  }
}

function renderPage(user, config) {
  var match = React.useReducer(reducer, initialState(undefined));
  var dispatch = match[1];
  var state = match[0];
  var router = Router.useRouter();
  var onSendClick = function (param) {
    var contact_name = state.name;
    var contact_email = state.email;
    var contact_message = state.message;
    var contact_reCaptcha = state.reCaptcha;
    var contact = {
      name: contact_name,
      email: contact_email,
      message: contact_message,
      reCaptcha: contact_reCaptcha
    };
    var validation = Common_Contact.validateContact(contact);
    Curry._1(dispatch, {
          TAG: /* SetContactError */5,
          _0: undefined
        });
    Curry._1(dispatch, {
          TAG: /* SetValidation */6,
          _0: validation
        });
    if (Common_Contact.hasErrors(validation)) {
      return ;
    }
    Curry._1(dispatch, {
          TAG: /* SetIsSubmitting */4,
          _0: true
        });
    var onError = function (param) {
      Curry._1(dispatch, {
            TAG: /* SetContactError */5,
            _0: "RequestFailed"
          });
      return Curry._1(dispatch, {
                  TAG: /* SetIsSubmitting */4,
                  _0: false
                });
    };
    var onSuccess = function (json) {
      var match = json.result;
      if (match === "Error") {
        Curry._1(dispatch, {
              TAG: /* SetValidation */6,
              _0: json.validation
            });
        Curry._1(dispatch, {
              TAG: /* SetContactError */5,
              _0: undefined
            });
        Curry._1(dispatch, {
              TAG: /* SetIsSubmitting */4,
              _0: false
            });
        return Curry._1(dispatch, /* IncrementContactAttemptCount */0);
      } else {
        router.push(Common_Url.contactSuccess(undefined));
        return ;
      }
    };
    Client_User.contact(contact, onSuccess, onError);
    
  };
  var contactError = state.contactError;
  var contactError$1 = contactError !== undefined ? "An error occurred when trying to send your message. Please try again." : undefined;
  var nameError = Belt_Option.map(state.validation.name, Common_Contact.nameErrorToString);
  var emailError = Belt_Option.map(state.validation.email, Common_Contact.emailErrorToString);
  var messageError = Belt_Option.map(state.validation.message, Common_Contact.messageErrorToString);
  var reCaptchaError = Belt_Option.map(state.validation.reCaptcha, Common_Contact.reCaptchaErrorToString);
  return React.createElement(Page_Contact_View.make, {
              reCaptchaSiteKey: config.reCaptcha.siteKey,
              user: user,
              name: state.name,
              email: state.email,
              message: state.message,
              onNameChange: (function (name) {
                  return Curry._1(dispatch, {
                              TAG: /* SetName */0,
                              _0: name
                            });
                }),
              onEmailChange: (function (email) {
                  return Curry._1(dispatch, {
                              TAG: /* SetEmail */1,
                              _0: email
                            });
                }),
              onMessageChange: (function (message) {
                  return Curry._1(dispatch, {
                              TAG: /* SetMessage */2,
                              _0: message
                            });
                }),
              onReCaptchaChange: (function (reCaptcha) {
                  return Curry._1(dispatch, {
                              TAG: /* SetReCaptcha */3,
                              _0: reCaptcha
                            });
                }),
              nameError: nameError,
              emailError: emailError,
              messageError: messageError,
              reCaptchaError: reCaptchaError,
              onSendClick: onSendClick,
              isSubmitting: state.isSubmitting,
              contactError: contactError$1,
              contactAttemptCount: state.contactAttemptCount
            });
}

function $$default(param) {
  var user = Belt_Option.map(Caml_option.null_to_opt(param.userDto), Common_User.User.fromDto);
  return renderPage(user, param.config);
}

export {
  initialState ,
  reducer ,
  renderPage ,
  $$default ,
  $$default as default,
  
}
/* react Not a pure module */
