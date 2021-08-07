// props must only contain valid JSON types (no undefined values)
type props = {userDto: Common_User.User.dto}

type state = {
  currentPassword: string,
  newPassword: string,
  newPasswordConfirm: string,
  isSubmitting: bool,
  errors: Common_User.ChangePassword.errors,
}

type action =
  | SetCurrentPassword(string)
  | SetNewPassword(string)
  | SetNewPasswordConfirm(string)
  | SetIsSubmitting(bool)
  | SetErrors(Common_User.ChangePassword.errors)
