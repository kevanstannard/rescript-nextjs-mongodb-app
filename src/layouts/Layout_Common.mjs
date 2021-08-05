// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import Link from "next/link";
import * as Common_Url from "../modules/common/Common_Url.mjs";
import * as Component_Icon from "../components/Component_Icon.mjs";
import * as Component_Link from "../components/Component_Link.mjs";
import * as Component_HtmlEntity from "../components/Component_HtmlEntity.mjs";
import * as Component_ContentContainer from "../components/Component_ContentContainer.mjs";

function getHeaderLinks(user) {
  if (user !== undefined) {
    return [
            [
              "Home",
              Common_Url.home(undefined),
              undefined
            ],
            [
              "Contact",
              Common_Url.contact(undefined),
              undefined
            ],
            [
              "Account",
              Common_Url.account(undefined),
              undefined
            ],
            [
              "Log out",
              Common_Url.logout(undefined),
              undefined
            ],
            [
              "Github",
              Common_Url.github(undefined),
              {
                NAME: "Svg",
                VAL: "/static/octocat.svg"
              }
            ]
          ];
  } else {
    return [
            [
              "Home",
              Common_Url.home(undefined),
              undefined
            ],
            [
              "Contact",
              Common_Url.contact(undefined),
              undefined
            ],
            [
              "Sign up",
              Common_Url.signup(undefined),
              undefined
            ],
            [
              "Log in",
              Common_Url.login(undefined),
              undefined
            ],
            [
              "Github",
              Common_Url.github(undefined),
              {
                NAME: "Svg",
                VAL: "/static/octocat.svg"
              }
            ]
          ];
  }
}

function Layout_Common$Header$MobileIcon$OpenMenuButton(Props) {
  var title = Props.title;
  var onClick = Props.onClick;
  return React.createElement("button", {
              title: title,
              type: "button",
              onClick: onClick
            }, React.createElement(Component_Icon.Menu.make, {
                  size: "Large",
                  color: "Black"
                }));
}

var OpenMenuButton = {
  make: Layout_Common$Header$MobileIcon$OpenMenuButton
};

function Layout_Common$Header$MobileIcon$CloseMenuButton(Props) {
  var title = Props.title;
  var onClick = Props.onClick;
  return React.createElement("button", {
              title: title,
              type: "button",
              onClick: onClick
            }, React.createElement(Component_Icon.X.make, {
                  size: "Large",
                  color: "Black"
                }));
}

var CloseMenuButton = {
  make: Layout_Common$Header$MobileIcon$CloseMenuButton
};

function Layout_Common$Header$MobileIcon(Props) {
  var menuIsOpen = Props.menuIsOpen;
  var setMenuIsOpen = Props.setMenuIsOpen;
  if (menuIsOpen) {
    return React.createElement(Layout_Common$Header$MobileIcon$CloseMenuButton, {
                title: "Close menu",
                onClick: (function (param) {
                    return Curry._1(setMenuIsOpen, (function (param) {
                                  return false;
                                }));
                  })
              });
  } else {
    return React.createElement(Layout_Common$Header$MobileIcon$OpenMenuButton, {
                title: "Open menu",
                onClick: (function (param) {
                    return Curry._1(setMenuIsOpen, (function (param) {
                                  return true;
                                }));
                  })
              });
  }
}

var MobileIcon = {
  OpenMenuButton: OpenMenuButton,
  CloseMenuButton: CloseMenuButton,
  make: Layout_Common$Header$MobileIcon
};

function Layout_Common$Header$DesktopMenu(Props) {
  var user = Props.user;
  return React.createElement("div", undefined, getHeaderLinks(user).map(function (param) {
                  var icon = param[2];
                  var name = param[0];
                  var icon$1 = icon !== undefined ? (
                      icon.NAME === "Svg" ? React.createElement("img", {
                              className: "inline-block h-6",
                              src: icon.VAL
                            }) : React.createElement("img", {
                              className: "inline-block h-6",
                              src: icon.VAL
                            })
                    ) : null;
                  return React.createElement(Link, {
                              href: param[1],
                              children: React.createElement("a", {
                                    className: "font-medium hover:bg-gray-100 p-2 mr-2 rounded"
                                  }, icon$1, name),
                              key: name
                            });
                }));
}

var DesktopMenu = {
  make: Layout_Common$Header$DesktopMenu
};

function Layout_Common$Header$MobileMenu(Props) {
  var user = Props.user;
  return React.createElement("div", undefined, getHeaderLinks(user).map(function (param) {
                  var icon = param[2];
                  var name = param[0];
                  var icon$1 = icon !== undefined ? (
                      icon.NAME === "Svg" ? React.createElement("img", {
                              className: "inline-block h-6",
                              src: icon.VAL
                            }) : React.createElement("img", {
                              className: "inline-block h-6",
                              src: icon.VAL
                            })
                    ) : null;
                  return React.createElement(Link, {
                              href: param[1],
                              children: React.createElement("a", {
                                    key: name,
                                    className: "bg-gray-200 border-b border-white block py-2 font-medium hover:bg-gray-300 width-full text-right"
                                  }, React.createElement(Component_ContentContainer.make, {
                                        children: null
                                      }, icon$1, name)),
                              key: name
                            });
                }));
}

var MobileMenu = {
  make: Layout_Common$Header$MobileMenu
};

function Layout_Common$Header(Props) {
  var user = Props.user;
  var match = React.useState(function () {
        return false;
      });
  var menuIsOpen = match[0];
  var border = menuIsOpen ? "" : "border-b border-gray-200";
  return React.createElement("div", {
              className: "mb-8 " + border
            }, React.createElement("div", {
                  className: "py-2 lg:py-6"
                }, React.createElement(Component_ContentContainer.make, {
                      children: React.createElement("div", {
                            className: "flex items-center justify-between"
                          }, React.createElement("h1", undefined, React.createElement("a", {
                                    className: "flex items-center font-bold text-base sm:text-xl lg:text-2xl",
                                    href: Common_Url.home(undefined)
                                  }, React.createElement("img", {
                                        className: "w-5 mr-2",
                                        src: "/static/zeit-black-triangle.svg"
                                      }), "ReScript + NextJS + MongoDB")), React.createElement("div", undefined, React.createElement("div", {
                                    className: "hidden lg:block"
                                  }, React.createElement(Layout_Common$Header$DesktopMenu, {
                                        user: user
                                      })), React.createElement("div", {
                                    className: "lg:hidden"
                                  }, React.createElement(Layout_Common$Header$MobileIcon, {
                                        menuIsOpen: menuIsOpen,
                                        setMenuIsOpen: match[1]
                                      }))))
                    })), React.createElement("div", {
                  className: "lg:hidden"
                }, menuIsOpen ? React.createElement(Layout_Common$Header$MobileMenu, {
                        user: user
                      }) : null));
}

var Header = {
  getHeaderLinks: getHeaderLinks,
  MobileIcon: MobileIcon,
  DesktopMenu: DesktopMenu,
  MobileMenu: MobileMenu,
  make: Layout_Common$Header
};

function Layout_Common$Footer(Props) {
  var year = new Date().getFullYear().toString();
  return React.createElement("div", {
              className: "py-4"
            }, React.createElement("hr", {
                  className: "mb-4"
                }), React.createElement(Component_ContentContainer.make, {
                  children: React.createElement("div", {
                        className: "flex"
                      }, React.createElement("div", {
                            className: "w-1/2 whitespace-nowrap"
                          }, React.createElement(Component_HtmlEntity.make, {
                                code: "copy"
                              }), " " + year + " Your Company Name"), React.createElement("div", {
                            className: "w-1/2 text-right"
                          }, React.createElement(Component_Link.make, {
                                href: Common_Url.about(undefined),
                                children: "About this site"
                              })))
                }));
}

var Footer = {
  make: Layout_Common$Footer
};

var Link$1;

var HtmlEntity;

var ContentContainer;

var Icon;

export {
  Link$1 as Link,
  HtmlEntity ,
  ContentContainer ,
  Icon ,
  Header ,
  Footer ,
  
}
/* react Not a pure module */
