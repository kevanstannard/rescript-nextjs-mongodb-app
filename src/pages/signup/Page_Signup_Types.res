type props = {
  env: string,
  connected: bool,
  count: int,
  config: Common_ClientConfig.t,
}

type state = {
  email: string,
  password: string,
  reCaptcha: option<string>,
  // validation: Common_User.Signup.signupValidation,
  isSubmitting: bool,
  // error: option<error>,
}

type action =
  | SetEmail(string)
  | SetPassword(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
// | SetError(option<error>)
// | SetValidation(Common_User.Signup.signupValidation)
