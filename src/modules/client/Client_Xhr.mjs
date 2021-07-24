// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as Belt_Result from "rescript/lib/es6/belt_Result.js";

function sendJson(xhr, json) {
  xhr.setRequestHeader("Content-Type", "application/json");
  xhr.send(JSON.stringify(json));
  
}

function parseJson(xhr) {
  var text = xhr.responseText;
  if (text == null) {
    return {
            TAG: /* Error */1,
            _0: undefined
          };
  }
  try {
    return {
            TAG: /* Ok */0,
            _0: JSON.parse(text)
          };
  }
  catch (exn){
    return {
            TAG: /* Error */1,
            _0: undefined
          };
  }
}

function toResult(xhr) {
  var match = xhr.status;
  if (match === 200) {
    return Belt_Result.map(parseJson(xhr), (function (json) {
                  return /* Ok */{
                          _0: json
                        };
                }));
  }
  if (match >= 405) {
    if (match !== 500) {
      return {
              TAG: /* Error */1,
              _0: undefined
            };
    } else {
      return {
              TAG: /* Ok */0,
              _0: /* InternalServerError */4
            };
    }
  }
  if (match < 400) {
    return {
            TAG: /* Error */1,
            _0: undefined
          };
  }
  switch (match) {
    case 400 :
        return {
                TAG: /* Ok */0,
                _0: /* BadRequest */0
              };
    case 401 :
        return {
                TAG: /* Ok */0,
                _0: /* Unauthorized */3
              };
    case 402 :
        return {
                TAG: /* Error */1,
                _0: undefined
              };
    case 403 :
        return {
                TAG: /* Ok */0,
                _0: /* Forbidden */1
              };
    case 404 :
        return {
                TAG: /* Ok */0,
                _0: /* NotFound */2
              };
    
  }
}

function toCallback(result, onSuccess, onError) {
  if (result.TAG !== /* Ok */0) {
    return Curry._1(onError, undefined);
  }
  var response = result._0;
  if (typeof response === "number") {
    return Curry._1(onError, undefined);
  } else {
    return Curry._1(onSuccess, response._0);
  }
}

function get(url, onSuccess, onError, param) {
  var xhr = new XMLHttpRequest();
  xhr.onerror = (function (param) {
      return Curry._1(onError, undefined);
    });
  xhr.onload = (function (param) {
      return toCallback(toResult(xhr), onSuccess, onError);
    });
  xhr.open("GET", url);
  xhr.send();
  return xhr;
}

function post(url, body, onSuccess, onError, param) {
  var xhr = new XMLHttpRequest();
  xhr.onload = (function (param) {
      return toCallback(toResult(xhr), onSuccess, onError);
    });
  xhr.onerror = (function (param) {
      return Curry._1(onError, undefined);
    });
  xhr.open("POST", url);
  if (typeof body === "number") {
    xhr.send();
  } else if (body.TAG === /* Json */0) {
    sendJson(xhr, body._0);
  } else {
    xhr.send(body._0);
  }
  return xhr;
}

export {
  sendJson ,
  parseJson ,
  toResult ,
  toCallback ,
  get ,
  post ,
  
}
/* No side effect */
