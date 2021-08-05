let home = () => "/"

let contact = () => "/contact"

let contactSuccess = () => "/contact-success"

let signup = () => "/signup"

let signupSuccess = () => "/signup-success"

let login = () => "/login"

let logout = () => "/logout"

let account = () => "/account"

let activate = (userId, activationKey) => `/activate/${userId}/${activationKey}`

let resetPassword = (userId, resetPasswordKey) => `/reset-password/${userId}/${resetPasswordKey}`

let resetPasswordSuccess = () => "/reset-password-success"

let changeEmail = () => "/change-email"

let changeEmailConfirm = (userId, emailChangeKey) =>
  `/change-email-confirm/${userId}/${emailChangeKey}`

let changeEmailSuccess = () => "/change-email-success"

let changePassword = () => "/change-password"

let changePasswordSuccess = () => "/change-password-success"

let forgotPassword = () => "/forgot-password"

let forgotPasswordSuccess = () => "/forgot-password-success"
