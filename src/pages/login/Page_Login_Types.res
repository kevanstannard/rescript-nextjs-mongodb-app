// Important: The props must only contain valid JSON types
type props = {
  env: string,
  config: Common_ClientConfig.t,
}

type state = {
  email: string,
  password: string,
  validation: Common_User.Login.validation,
  isSubmitting: bool,
  loginError: option<Common_User.Login.loginError>,
}

type action =
  | SetEmail(string)
  | SetPassword(string)
  | SetIsSubmitting(bool)
  | SetLoginError(option<Common_User.Login.loginError>)
  | SetValidation(Common_User.Login.validation)
