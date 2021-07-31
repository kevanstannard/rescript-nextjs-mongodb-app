// Important: The props must only contain valid JSON types
type props = {
  env: string,
  config: Common_ClientConfig.t,
}

type state = {
  email: string,
  password: string,
  reCaptcha: option<string>,
  validation: Common_User.Signup.validation,
  isSubmitting: bool,
  signupError: option<Common_User.Signup.signupError>,
  signupAttemptCount: int,
}

type action =
  | SetEmail(string)
  | SetPassword(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetSignupError(option<Common_User.Signup.signupError>)
  | SetValidation(Common_User.Signup.validation)
  | IncrementSignupAttemptCount
