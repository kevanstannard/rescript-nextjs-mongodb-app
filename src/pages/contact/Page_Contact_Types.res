// props must only contain valid JSON types (no undefined values)
type props = {
  userDto: Js.Null.t<Common_User.User.dto>,
  clientConfig: Common_ClientConfig.t,
}

type state = {
  name: string,
  email: string,
  message: string,
  reCaptcha: option<string>,
  errors: Common_Contact.errors,
  isSubmitting: bool,
  attemptCount: int,
}

type action =
  | SetName(string)
  | SetEmail(string)
  | SetMessage(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_Contact.errors)
  | IncrementAttemptCount
