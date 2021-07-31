let home = () => "/"

let contact = () => "/contact"

let contactSuccess = () => "/contact-success"

let signup = () => "/signup"

let signupSuccess = () => "/signup-success"

let login = () => "/login"

let logout = () => "/logout"

let activate = (userId, activationKey) => `/activate/${userId}/${activationKey}`

let resetPassword = (userId, resetPasswordKey) => `/reset-password/${userId}/${resetPasswordKey}`

let changeEmailConfirm = (userId, emailChangeKey) =>
  `/change-email-confirm/${userId}/${emailChangeKey}`
