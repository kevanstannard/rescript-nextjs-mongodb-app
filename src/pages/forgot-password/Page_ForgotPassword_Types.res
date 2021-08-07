// props must only contain valid JSON types (no undefined values)
type props = {
  userDto: Js.Null.t<Common_User.User.dto>,
  clientConfig: Common_ClientConfig.t,
}

type state = {
  email: string,
  reCaptcha: option<string>,
  isSubmitting: bool,
  errors: Common_User.ForgotPassword.errors,
  attemptCount: int,
}

type action =
  | SetEmail(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.ForgotPassword.errors)
  | IncrementAttemptCount
