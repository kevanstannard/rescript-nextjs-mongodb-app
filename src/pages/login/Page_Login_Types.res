type state = {
  email: string,
  password: string,
  isSubmitting: bool,
  errors: Common_User.Login.errors,
}

type action =
  | SetEmail(string)
  | SetPassword(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.Login.errors)
