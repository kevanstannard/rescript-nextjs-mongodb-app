type props = {userDto: Common_User.User.dto}

type state = {
  email: string,
  isSubmitting: bool,
  errors: Common_User.ChangeEmail.changeEmailErrors,
}

type action =
  | SetEmail(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.ChangeEmail.changeEmailErrors)
