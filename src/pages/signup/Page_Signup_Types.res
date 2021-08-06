// `props` must only contain valid JSON types (no undefined values)
type props = {clientConfig: Common_ClientConfig.t}

type state = {
  email: string,
  password: string,
  reCaptcha: option<string>,
  isSubmitting: bool,
  signupAttemptCount: int,
  errors: Common_User.Signup.errors,
}

type action =
  | SetEmail(string)
  | SetPassword(string)
  | SetReCaptcha(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.Signup.errors)
  | IncrementSignupAttemptCount
