// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";

function Component_AlertMessage(Props) {
  var type_ = Props.type_;
  var children = Props.children;
  var bgColor = type_ === "Error" ? "bg-red-200" : (
      type_ === "Info" ? "bg-blue-200" : "bg-green-200"
    );
  return React.createElement("div", {
              className: bgColor + " p-4 mb-6"
            }, children);
}

var make = Component_AlertMessage;

export {
  make ,
  
}
/* react Not a pure module */