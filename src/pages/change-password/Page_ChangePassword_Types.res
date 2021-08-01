type props = {user: Js.Null.t<Common_User.User.dto>}

type requestError = [#RequestFailed]

type state = {
  currentPassword: string,
  newPassword: string,
  newPasswordConfirm: string,
  isSubmitting: bool,
  validation: Common_User.ChangePassword.changePasswordValidation,
  requestError: option<requestError>,
}

type action =
  | SetCurrentPassword(string)
  | SetNewPassword(string)
  | SetNewPasswordConfirm(string)
  | SetIsSubmitting(bool)
  | SetRequestError(option<requestError>)
  | SetValidation(Common_User.ChangePassword.changePasswordValidation)
