let signup = (signup: Common_User.Signup.signup, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/signup",
    ~body=Json(signup->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let login = (login: Common_User.Login.login, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/login",
    ~body=Json(login->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let contact = (contact: Common_Contact.contact, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/contact",
    ~body=Json(contact->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let changePassword = (
  changePassword: Common_User.ChangePassword.changePassword,
  onSuccess,
  onError,
) => {
  Client_Xhr.post(
    ~url="/api/change-password",
    ~body=Json(changePassword->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let changeEmail = (changeEmail: Common_User.ChangeEmail.changeEmail, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/change-email",
    ~body=Json(changeEmail->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let forgotPassword = (
  forgotPassword: Common_User.ForgotPassword.forgotPassword,
  onSuccess,
  onError,
) => {
  Client_Xhr.post(
    ~url="/api/forgot-password",
    ~body=Json(forgotPassword->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let resetPassword = (
  resetPassword: Common_User.ResetPassword.resetPassword,
  onSuccess,
  onError,
) => {
  Client_Xhr.post(
    ~url="/api/reset-password",
    ~body=Json(resetPassword->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}
