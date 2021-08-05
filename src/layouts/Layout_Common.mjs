// Generated by ReScript, PLEASE EDIT WITH CARE

import * as Curry from "rescript/lib/es6/curry.js";
import * as React from "react";
import * as Common_Url from "../modules/common/Common_Url.mjs";
import * as Component_Link from "../components/Component_Link.mjs";
import * as Component_Button from "../components/Component_Button.mjs";
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

function Layout_Common$Header$MobileIcon(Props) {
  var menuIsOpen = Props.menuIsOpen;
  var setMenuIsOpen = Props.setMenuIsOpen;
  if (menuIsOpen) {
    return React.createElement(Component_Button.IconButton.make, {
                title: "Close menu",
                onClick: (function (param) {
                    return Curry._1(setMenuIsOpen, (function (param) {
                                  return false;
                                }));
                  }),
                icon: "X",
                color: "None",
                state: "Ready"
              });
  } else {
    return React.createElement(Component_Button.IconButton.make, {
                title: "Open menu",
                onClick: (function (param) {
                    return Curry._1(setMenuIsOpen, (function (param) {
                                  return true;
                                }));
                  }),
                icon: "Menu",
                color: "None",
                state: "Ready"
              });
  }
}

var MobileIcon = {
  make: Layout_Common$Header$MobileIcon
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
                  return React.createElement("div", {
                              key: name,
                              className: "py-2 px-4 bg-green-600 hover:bg-green-700 text-white font-medium text-right border-b border-green-500"
                            }, React.createElement(Component_ContentContainer.make, {
                                  children: React.createElement("a", {
                                        href: param[1]
                                      }, icon$1, name)
                                }));
                }));
}

var MobileMenu = {
  make: Layout_Common$Header$MobileMenu
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
                  return React.createElement("a", {
                              key: name,
                              className: "font-medium hover:bg-green-600 p-2 text-white mr-2 rounded",
                              href: param[1]
                            }, icon$1, name);
                }));
}

var DesktopMenu = {
  make: Layout_Common$Header$DesktopMenu
};

function Layout_Common$Header(Props) {
  var user = Props.user;
  var match = React.useState(function () {
        return false;
      });
  var menuIsOpen = match[0];
  return React.createElement("div", {
              className: "mb-8"
            }, React.createElement("div", {
                  className: "bg-green-500   py-2 lg:py-6"
                }, React.createElement(Component_ContentContainer.make, {
                      children: React.createElement("div", {
                            className: "flex items-center justify-between"
                          }, React.createElement("h1", undefined, React.createElement("a", {
                                    className: "flex items-center text-white font-bold text-xl lg:text-2xl",
                                    href: Common_Url.home(undefined)
                                  }, "ReScript + NextJS + MongoDB")), React.createElement("div", undefined, React.createElement("div", {
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
  MobileMenu: MobileMenu,
  DesktopMenu: DesktopMenu,
  make: Layout_Common$Header
};

function Layout_Common$Footer(Props) {
  return React.createElement("div", {
              className: "py-4"
            }, React.createElement("hr", {
                  className: "mb-4"
                }), React.createElement(Component_ContentContainer.make, {
                  children: React.createElement("div", {
                        className: "flex"
                      }, React.createElement("div", {
                            className: "w-1/2 text-sm md:text-base"
                          }, React.createElement(Component_HtmlEntity.make, {
                                code: "copy"
                              }), " 2021 Pixel Papercraft"), React.createElement("div", {
                            className: "w-1/2 text-sm md:text-base text-right"
                          }, React.createElement(Component_Link.make, {
                                href: Common_Url.privacy(undefined),
                                children: "Privacy Policy"
                              })))
                }));
}

var Footer = {
  make: Layout_Common$Footer
};

var Link;

var HtmlEntity;

var ContentContainer;

var Icon;

export {
  Link ,
  HtmlEntity ,
  ContentContainer ,
  Icon ,
  Header ,
  Footer ,
  
}
/* react Not a pure module */
