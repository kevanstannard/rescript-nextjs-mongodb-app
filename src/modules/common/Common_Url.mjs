// Generated by ReScript, PLEASE EDIT WITH CARE


function home(param) {
  return "/";
}

function contact(param) {
  return "/contact";
}

function signup(param) {
  return "/signup";
}

function signupSuccess(param) {
  return "/signup-success";
}

function login(param) {
  return "/login";
}

function logout(param) {
  return "/logout";
}

function activate(userId, activationKey) {
  return "/activate/" + userId + "/" + activationKey;
}

function resetPassword(userId, resetPasswordKey) {
  return "/reset-password/" + userId + "/" + resetPasswordKey;
}

function changeEmailConfirm(userId, emailChangeKey) {
  return "/change-email-confirm/" + userId + "/" + emailChangeKey;
}

export {
  home ,
  contact ,
  signup ,
  signupSuccess ,
  login ,
  logout ,
  activate ,
  resetPassword ,
  changeEmailConfirm ,
  
}
/* No side effect */
