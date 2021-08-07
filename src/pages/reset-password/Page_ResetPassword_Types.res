type params = {
  userId: string,
  resetPasswordKey: string,
}

// props must only contain valid JSON types (no undefined values)
type props = {
  config: Common_ClientConfig.t,
  userDto: Js.Null.t<Common_User.User.dto>,
  userId: string,
  resetPasswordKey: string,
  resetPasswordErrorsDto: Common_User.ResetPassword.errorsDto,
}

type state = {
  password: string,
  passwordConfirm: string,
  reCaptcha: option<string>,
  isSubmitting: bool,
  errors: Common_User.ResetPassword.errors,
}

type action =
  | SetPassword(string)
  | SetPasswordConfirm(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.ResetPassword.errors)
