// Generated by ReScript, PLEASE EDIT WITH CARE

import * as React from "react";
import Link from "next/link";

function Component_Link(Props) {
  var href = Props.href;
  var children = Props.children;
  return React.createElement(Link, {
              href: href,
              children: React.createElement("a", {
                    className: "font-medium hover:underline text-green-600"
                  }, children)
            });
}

var make = Component_Link;

export {
  make ,
  
}
/* react Not a pure module */
