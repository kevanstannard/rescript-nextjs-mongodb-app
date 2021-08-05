type params = {
  userId: string,
  resetPasswordKey: string,
}

type props = {
  config: Common_ClientConfig.t,
  userDto: Js.Null.t<Common_User.User.dto>,
  userId: string,
  resetPasswordKey: string,
  resetPasswordErrorsDto: Common_User.ResetPassword.resetPasswordErrorsDto,
}

type state = {
  password: string,
  passwordConfirm: string,
  reCaptcha: option<string>,
  isSubmitting: bool,
  errors: Common_User.ResetPassword.resetPasswordErrors,
}

type action =
  | SetPassword(string)
  | SetPasswordConfirm(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.ResetPassword.resetPasswordErrors)
