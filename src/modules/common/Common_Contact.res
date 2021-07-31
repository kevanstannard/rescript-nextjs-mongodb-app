type contact = {
  name: string,
  email: string,
  message: string,
  reCaptcha: option<string>,
}

type contactError = [#RequestFailed | #UnknownError]
type nameError = [#NameEmpty]
type emailError = [#EmailEmpty | #EmailInvalid]
type messageError = [#MessageEmpty]
type reCaptchaError = [#ReCaptchaEmpty | #ReCaptchaInvalid]

type validation = {
  name: option<nameError>,
  email: option<emailError>,
  message: option<messageError>,
  reCaptcha: option<reCaptchaError>,
}

type contactResult = {
  result: [#Ok | #Error],
  validation: validation,
}

external asContactResult: Js.Json.t => contactResult = "%identity"

let isValid = (validation: validation) => {
  Belt.Option.isNone(validation.name) &&
  Belt.Option.isNone(validation.email) &&
  Belt.Option.isNone(validation.message) &&
  Belt.Option.isNone(validation.reCaptcha)
}

let hasErrors = validation => !isValid(validation)

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

let validateName = (name): option<nameError> => {
  let nameTrimmed = String.trim(name)
  if Validator.isEmpty(nameTrimmed) {
    Some(#NameEmpty)
  } else {
    None
  }
}

let validateMessage = (message): option<messageError> => {
  let messageTrimmed = String.trim(message)
  if Validator.isEmpty(messageTrimmed) {
    Some(#MessageEmpty)
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

let validateContact = ({email, name, message, reCaptcha}: contact): validation => {
  email: validateEmail(email),
  name: validateName(name),
  message: validateMessage(message),
  reCaptcha: validateReCaptcha(reCaptcha),
}

let emailErrorToString = (error: emailError): string => {
  switch error {
  | #EmailEmpty => "Enter an email address"
  | #EmailInvalid => "Enter a valid email address"
  }
}

let nameErrorToString = (error: nameError): string => {
  switch error {
  | #NameEmpty => "Enter a name"
  }
}

let messageErrorToString = (error: messageError): string => {
  switch error {
  | #MessageEmpty => "Enter a message"
  }
}

let reCaptchaErrorToString = (error: reCaptchaError): string => {
  switch error {
  | #ReCaptchaEmpty => "Are you sure you're a robot?"
  | #ReCaptchaInvalid => "Are you sure you're a robot?"
  }
}
