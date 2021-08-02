module User = {
  type t = {
    id: string,
    email: string,
    emailChange: option<string>,
  }

  type dto = {
    id: string,
    email: string,
    emailChange: Js.Null.t<string>,
  }

  let toDto = (user: t): dto => {
    {
      id: user.id,
      email: user.email,
      emailChange: Js.Null.fromOption(user.emailChange),
    }
  }

  let fromDto = (dto: dto): t => {
    {
      id: dto.id,
      email: dto.email,
      emailChange: Js.Null.toOption(dto.emailChange),
    }
  }
}

module Signup = {
  type signup = {
    email: string,
    password: string,
    reCaptcha: option<string>,
  }

  type signupError = [#RequestFailed | #UnknownError]

  type emailError = [#EmailEmpty | #EmailInvalid | #EmailNotAvailable]
  type passwordError = [#PasswordEmpty]
  type reCaptchaError = [#ReCaptchaEmpty | #ReCaptchaInvalid]

  type validation = {
    email: option<emailError>,
    password: option<passwordError>,
    reCaptcha: option<reCaptchaError>,
  }

  type signupResult = {
    result: [#Ok | #Error],
    validation: validation,
  }

  external asSignupResult: Js.Json.t => signupResult = "%identity"

  let isValid = (validation: validation): bool => {
    Belt.Option.isNone(validation.email) &&
    Belt.Option.isNone(validation.password) &&
    Belt.Option.isNone(validation.reCaptcha)
  }

  let hasErrors = (validation: validation): bool => !isValid(validation)

  let validateEmail = (email): option<emailError> => {
    let emailTrimmed = String.trim(email)
    if Validator.isEmpty(emailTrimmed) {
      Some(#EmailEmpty)
    } else if !Validator.isEmail(emailTrimmed) {
      Some(#EmailInvalid)
    } else {
      None
    }
  }

  let validatePassword = (password): option<passwordError> => {
    if Validator.isEmpty(password) {
      Some(#PasswordEmpty)
    } else {
      None
    }
  }

  let validateReCaptcha = (reCaptcha): option<reCaptchaError> => {
    switch reCaptcha {
    | Some(_) => None
    | None => Some(#ReCaptchaEmpty)
    }
  }

  let validateSignup = ({email, password, reCaptcha}: signup): validation => {
    email: validateEmail(email),
    password: validatePassword(password),
    reCaptcha: validateReCaptcha(reCaptcha),
  }

  let signupErrorToString = (error: signupError): string => {
    switch error {
    | #RequestFailed => "There was a problem signing up, please try again"
    | #UnknownError => "There was a problem signing up, please try again"
    }
  }

  let emailErrorToString = (error: emailError): string => {
    switch error {
    | #EmailEmpty => "Enter an email address"
    | #EmailInvalid => "Enter a valid email address"
    | #EmailNotAvailable => "That email address is not available"
    }
  }

  let passwordErrorToString = (error: passwordError): string => {
    switch error {
    | #PasswordEmpty => "Enter a password"
    }
  }

  let reCaptchaErrorToString = (error: reCaptchaError): string => {
    switch error {
    | #ReCaptchaEmpty => "Are you sure you're a robot?"
    | #ReCaptchaInvalid => "Are you sure you're a robot?"
    }
  }
}

module Login = {
  type login = {
    email: string,
    password: string,
  }

  type loginError = [#LoginFailed | #AccountInactive | #RequestFailed | #UnknownError]
  type emailError = [#EmailEmpty | #EmailInvalid]
  type passwordError = [#PasswordEmpty]

  type validation = {
    email: option<emailError>,
    password: option<passwordError>,
  }

  type loginResult = {
    result: [#Ok | #Error],
    error: option<loginError>,
    nextUrl: option<string>,
  }

  external asLoginResult: Js.Json.t => loginResult = "%identity"

  let isValid = (validation: validation): bool => {
    Belt.Option.isNone(validation.email) && Belt.Option.isNone(validation.password)
  }

  let hasErrors = (validation: validation): bool => !isValid(validation)

  let validateEmail = (email): option<emailError> => {
    let emailTrimmed = String.trim(email)
    if Validator.isEmpty(emailTrimmed) {
      Some(#EmailEmpty)
    } else if !Validator.isEmail(emailTrimmed) {
      Some(#EmailInvalid)
    } else {
      None
    }
  }

  let validatePassword = (password): option<passwordError> => {
    if Validator.isEmpty(password) {
      Some(#PasswordEmpty)
    } else {
      None
    }
  }

  let validateLogin = ({email, password}: login): validation => {
    email: validateEmail(email),
    password: validatePassword(password),
  }

  let loginErrorToString = (error: loginError): string => {
    switch error {
    | #RequestFailed => "There was a problem logging in, please try again."
    | #UnknownError => "There was a problem logging in, please try again."
    | #LoginFailed => "Your email or password is not correct."
    | #AccountInactive => "Your account has not been activated."
    }
  }

  let emailErrorToString = (error: emailError): string => {
    switch error {
    | #EmailEmpty => "Enter your email address"
    | #EmailInvalid => "Enter a valid email address"
    }
  }

  let passwordErrorToString = (error: passwordError): string => {
    switch error {
    | #PasswordEmpty => "Enter a password"
    }
  }
}

module Logout = {
  type logoutResult = {result: [#Ok]}
}

module ChangeEmail = {
  type changeEmail = {email: string}

  type changeEmailError = [
    | #RequestFailed
    | #UserNotFound
    | #AccountNotActivated
    | #SameAsCurrentEmail
    | #EmailNotAvailable
  ]

  type emailError = [#EmailEmpty | #EmailInvalid]

  type changeEmailErrors = {
    changeEmail: option<changeEmailError>,
    email: option<emailError>,
  }

  type changeEmailResult = {
    result: [#Ok | #Error],
    errors: changeEmailErrors,
  }

  external asChangeEmailResult: Js.Json.t => changeEmailResult = "%identity"

  let hasErrors = (errors: changeEmailErrors): bool => {
    Belt.Option.isSome(errors.changeEmail) || Belt.Option.isSome(errors.email)
  }

  let validateEmail = (email): option<emailError> => {
    let emailTrimmed = String.trim(email)
    if Validator.isEmpty(emailTrimmed) {
      Some(#EmailEmpty)
    } else if !Validator.isEmail(emailTrimmed) {
      Some(#EmailInvalid)
    } else {
      None
    }
  }

  let validateChangeEmail = ({email}: changeEmail): changeEmailErrors => {
    changeEmail: None,
    email: validateEmail(email),
  }

  let generalError = "An error occurred when trying to change your email. Please try again."

  let changeEmailErrorToString = (error: changeEmailError): string => {
    switch error {
    | #RequestFailed => generalError
    | #UserNotFound => generalError
    | #AccountNotActivated => generalError
    | #SameAsCurrentEmail => "The email address you provided is the same as your current email address."
    | #EmailNotAvailable => "That email address is not available."
    }
  }

  let emailErrorToString = (error: emailError): string => {
    switch error {
    | #EmailEmpty => "Enter an email address"
    | #EmailInvalid => "Enter a valid email address"
    }
  }
}

module ChangePassword = {
  type changePassword = {
    currentPassword: string,
    newPassword: string,
    newPasswordConfirm: string,
  }

  type changePasswordError = [
    | #UnknownError
    | #UserNotFound
    | #AccountNotActivated
    | #CurrentPasswordInvalid
  ]
  type currentPasswordError = [#CurrentPasswordEmpty]
  type newPasswordError = [#NewPasswordEmpty]
  type newPasswordConfirmError = [#NewPasswordConfirmEmpty | #NewPasswordConfirmMismatch]

  type changePasswordValidation = {
    changePassword: option<changePasswordError>,
    currentPassword: option<currentPasswordError>,
    newPassword: option<newPasswordError>,
    newPasswordConfirm: option<newPasswordConfirmError>,
  }

  type changePasswordResult = {
    result: [#Ok | #Error],
    validation: changePasswordValidation,
  }

  external asChangePasswordResult: Js.Json.t => changePasswordResult = "%identity"

  let hasErrors = (validation: changePasswordValidation): bool => {
    Belt.Option.isSome(validation.changePassword) ||
    Belt.Option.isSome(validation.currentPassword) ||
    Belt.Option.isSome(validation.newPassword) ||
    Belt.Option.isSome(validation.newPasswordConfirm)
  }

  let validateCurrentPassword = (currentPassword): option<currentPasswordError> => {
    if Validator.isEmpty(currentPassword) {
      Some(#CurrentPasswordEmpty)
    } else {
      None
    }
  }

  let validateNewPassword = (newPassword): option<newPasswordError> => {
    if Validator.isEmpty(newPassword) {
      Some(#NewPasswordEmpty)
    } else {
      None
    }
  }

  let validateNewPasswordConfirm = (newPassword, newPasswordConfirm): option<
    newPasswordConfirmError,
  > => {
    if Validator.isEmpty(newPasswordConfirm) {
      Some(#NewPasswordConfirmEmpty)
    } else if newPassword != newPasswordConfirm {
      Some(#NewPasswordConfirmMismatch)
    } else {
      None
    }
  }

  let validateChangePassword = (
    {currentPassword, newPassword, newPasswordConfirm}: changePassword,
  ): changePasswordValidation => {
    changePassword: None,
    currentPassword: validateCurrentPassword(currentPassword),
    newPassword: validateNewPassword(newPassword),
    newPasswordConfirm: validateNewPasswordConfirm(newPassword, newPasswordConfirm),
  }

  let changePasswordValidationErrorToString = (error: changePasswordError): string => {
    switch error {
    | #UnknownError => "An error occurred when trying to change your password. Please try again."
    | #UserNotFound => "An error occurred when trying to change your password. Please try again."
    | #AccountNotActivated => "An error occurred when trying to change your password. Please try again."
    | #CurrentPasswordInvalid => "The current password you entered is not correct. Please try again."
    }
  }

  let currentPasswordValidationErrorToString = (error: currentPasswordError): string => {
    switch error {
    | #CurrentPasswordEmpty => "Enter your current password"
    }
  }

  let newPasswordValidationErrorToString = (error: newPasswordError): string => {
    switch error {
    | #NewPasswordEmpty => "Enter your new password"
    }
  }

  let newPasswordConfirmValidationErrorToString = (error: newPasswordConfirmError): string => {
    switch error {
    | #NewPasswordConfirmEmpty => "Re-enter your new password"
    | #NewPasswordConfirmMismatch => "This does not match the password above"
    }
  }
}
