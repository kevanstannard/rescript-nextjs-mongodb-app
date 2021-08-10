type contact = {
  name: string,
  email: string,
  message: string,
  reCaptcha: option<string>,
}

type contactError = [#RequestFailed]
type nameError = [#NameEmpty]
type emailError = [#EmailEmpty | #EmailInvalid]
type messageError = [#MessageEmpty]
type reCaptchaError = [#ReCaptchaEmpty | #ReCaptchaInvalid]

type errors = {
  contact: option<contactError>,
  name: option<nameError>,
  email: option<emailError>,
  message: option<messageError>,
  reCaptcha: option<reCaptchaError>,
}

type contactResult = {errors: errors}

external asContactResult: Js.Json.t => contactResult = "%identity"

let emptyErrors = () => {
  contact: None,
  name: None,
  email: None,
  message: None,
  reCaptcha: None,
}

let hasErrors = (errors: errors) => {
  Belt.Option.isSome(errors.contact) ||
  Belt.Option.isSome(errors.name) ||
  Belt.Option.isSome(errors.email) ||
  Belt.Option.isSome(errors.message) ||
  Belt.Option.isSome(errors.reCaptcha)
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

let validateContact = ({email, name, message, reCaptcha}: contact): errors => {
  contact: None,
  email: validateEmail(email),
  name: validateName(name),
  message: validateMessage(message),
  reCaptcha: validateReCaptcha(reCaptcha),
}

let contactErrorToString = (error: contactError): string => {
  switch error {
  | #RequestFailed => "There was a problem sending your message. Please try again."
  }
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

module Codec = {
  let toFields = ({name, email, message, reCaptcha}: contact) => (name, email, message, reCaptcha)

  let fromFields = ((name, email, message, reCaptcha)) =>
    {name: name, email: email, message: message, reCaptcha: reCaptcha}->Ok

  let codec = Jzon.object4(
    toFields,
    fromFields,
    Jzon.field("name", Jzon.string),
    Jzon.field("email", Jzon.string),
    Jzon.field("message", Jzon.string),
    Jzon.field("reCaptcha", Jzon.string)->Jzon.optional,
  )

  let encode = (contact: contact) => codec->Jzon.encode(contact)

  let decode = (json: Js.Json.t) => codec->Common_Codec.decodeWithErrorAsString(json)
}
