type props = {
  user: Js.Null.t<Common_User.User.t>,
  config: Common_ClientConfig.t,
}

type state = {
  name: string,
  email: string,
  message: string,
  reCaptcha: option<string>,
  validation: Common_Contact.validation,
  isSubmitting: bool,
  contactError: option<Common_Contact.contactError>,
  contactAttemptCount: int,
}

type action =
  | SetName(string)
  | SetEmail(string)
  | SetMessage(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetContactError(option<Common_Contact.contactError>)
  | SetValidation(Common_Contact.validation)
  | IncrementContactAttemptCount
