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
    errors: option<changeEmailErrors>,
  }

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

  let emailValidationErrorToString = (error: emailError): string => {
    switch error {
    | #EmailEmpty => "Enter an email address"
    | #EmailInvalid => "Enter a valid email address"
    }
  }
}
