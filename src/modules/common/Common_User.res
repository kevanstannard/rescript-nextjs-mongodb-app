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

  type loginError = [#RequestFailed | #UnknownError]

  type emailError = [#EmailEmpty | #EmailInvalid]
  type passwordError = [#PasswordEmpty]

  type validation = {
    email: option<emailError>,
    password: option<passwordError>,
  }

  type loginResult = {
    result: [#Ok | #Error],
    validation: validation,
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
    | #RequestFailed => "There was a problem logging in, please try again"
    | #UnknownError => "There was a problem logging in, please try again"
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
