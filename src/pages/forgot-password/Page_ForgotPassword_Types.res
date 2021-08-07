// props must only contain valid JSON types (no undefined values)
type props = {userDto: Js.Null.t<Common_User.User.dto>}

type state = {
  email: string,
  isSubmitting: bool,
  errors: Common_User.ForgotPassword.errors,
}

type action =
  | SetEmail(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.ForgotPassword.errors)
