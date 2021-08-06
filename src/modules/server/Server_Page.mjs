// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Common_Url from "../common/Common_Url.mjs";
import * as Caml_option from "rescript/lib/es6/caml_option.js";

function props(props$1) {
  return {
          props: Caml_option.some(props$1),
          redirect: undefined,
          notFound: undefined
        };
}

function noProps(param) {
  return props({});
}

function redirect(url) {
  return {
          props: undefined,
          redirect: {
            destination: url,
            permanent: false
          },
          notFound: undefined
        };
}

function redirectHome(param) {
  return {
          props: undefined,
          redirect: {
            destination: Common_Url.home(undefined),
            permanent: false
          },
          notFound: undefined
        };
}

function redirectLogin(param) {
  return {
          props: undefined,
          redirect: {
            destination: Common_Url.login(undefined),
            permanent: false
          },
          notFound: undefined
        };
}

export {
  props ,
  noProps ,
  redirect ,
  redirectHome ,
  redirectLogin ,
  
}
/* No side effect */
