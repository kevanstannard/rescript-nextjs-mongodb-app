// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import * as Zxcvbn from "zxcvbn";

function Component_PasswordStrength(Props) {
  var password = Props.password;
  var score = password.length === 0 ? -1 : Zxcvbn(password).score;
  var className;
  switch (score) {
    case 0 :
        className = "w-1/5 bg-red-500";
        break;
    case 1 :
        className = "w-2/5 bg-yellow-500";
        break;
    case 2 :
        className = "w-3/5 bg-indigo-500";
        break;
    case 3 :
        className = "w-4/5 bg-blue-500";
        break;
    case 4 :
        className = "w-5/5 bg-green-500";
        break;
    default:
      className = "bg-gray-100 w-0";
  }
  return React.createElement("div", {
              className: "w-full bg-gray-100 h-2"
            }, React.createElement("div", {
                  className: "h-full " + className
                }));
}

var make = Component_PasswordStrength;

export {
  make ,
  
}
/* react Not a pure module */
