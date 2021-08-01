// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Client_Xhr from "./Client_Xhr.mjs";

function signup(signup$1, onSuccess, onError) {
  return Client_Xhr.post("/api/signup", {
              TAG: /* Json */0,
              _0: signup$1
            }, onSuccess, onError, undefined);
}

function login(login$1, onSuccess, onError) {
  return Client_Xhr.post("/api/login", {
              TAG: /* Json */0,
              _0: login$1
            }, onSuccess, onError, undefined);
}

function contact(contact$1, onSuccess, onError) {
  return Client_Xhr.post("/api/contact", {
              TAG: /* Json */0,
              _0: contact$1
            }, onSuccess, onError, undefined);
}

function changePassword(changePassword$1, onSuccess, onError) {
  return Client_Xhr.post("/api/change-password", {
              TAG: /* Json */0,
              _0: changePassword$1
            }, onSuccess, onError, undefined);
}

export {
  signup ,
  login ,
  contact ,
  changePassword ,
  
}
/* No side effect */
