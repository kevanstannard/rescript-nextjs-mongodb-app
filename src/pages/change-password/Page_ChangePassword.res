open Page_ChangePassword_Types

let initialState = () => {
  currentPassword: "",
  newPassword: "",
  newPasswordConfirm: "",
  isSubmitting: false,
  requestError: None,
  validation: {
    changePassword: None,
    currentPassword: None,
    newPassword: None,
    newPasswordConfirm: None,
  },
}

let reducer = (state, action) => {
  switch action {
  | SetCurrentPassword(currentPassword) => {...state, currentPassword: currentPassword}
  | SetNewPassword(newPassword) => {...state, newPassword: newPassword}
  | SetNewPasswordConfirm(newPasswordConfirm) => {...state, newPasswordConfirm: newPasswordConfirm}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetRequestError(requestError) => {...state, requestError: requestError}
  | SetValidation(validation) => {...state, validation: validation}
  }
}

let renderPage = (user: Common_User.User.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onChangePasswordClick = _ => {
    let changePassword: Common_User.ChangePassword.changePassword = {
      currentPassword: state.currentPassword,
      newPassword: state.newPassword,
      newPasswordConfirm: state.newPasswordConfirm,
    }

    let changePasswordValidation = Common_User.ChangePassword.validateChangePassword(changePassword)

    dispatch(SetRequestError(None))
    dispatch(SetValidation(changePasswordValidation))

    if !Common_User.ChangePassword.hasErrors(changePasswordValidation) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        dispatch(SetRequestError(Some(#RequestFailed)))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let changePasswordResult = json->Common_User.ChangePassword.asChangePasswordResult
        switch changePasswordResult.result {
        | #Ok => router->Next.Router.push(Common_Url.changePasswordSuccess())
        | #Error => {
            dispatch(SetValidation(changePasswordResult.validation))
            dispatch(SetIsSubmitting(false))
          }
        }
      }

      Client_User.changePassword(changePassword, onSuccess, onError)->ignore
    }
  }

  let requestError = switch state.requestError {
  | Some(requestError) =>
    switch requestError {
    | #RequestFailed =>
      Some("An error occurred when trying to change your password. Please try again.")
    }
  | None =>
    state.validation.changePassword->Belt.Option.map(
      Common_User.ChangePassword.changePasswordValidationErrorToString,
    )
  }

  let currentPasswordError =
    state.validation.currentPassword->Belt.Option.map(
      Common_User.ChangePassword.currentPasswordValidationErrorToString,
    )

  let newPasswordError =
    state.validation.newPassword->Belt.Option.map(
      Common_User.ChangePassword.newPasswordValidationErrorToString,
    )

  let newPasswordConfirmError =
    state.validation.newPasswordConfirm->Belt.Option.map(
      Common_User.ChangePassword.newPasswordConfirmValidationErrorToString,
    )

  <Page_ChangePassword_View
    user={user}
    currentPassword={state.currentPassword}
    newPassword={state.newPassword}
    newPasswordConfirm={state.newPasswordConfirm}
    onCurrentPasswordChange={currentPassword => dispatch(SetCurrentPassword(currentPassword))}
    onNewPasswordChange={newPassword => dispatch(SetNewPassword(newPassword))}
    onNewPasswordConfirmChange={newPasswordConfirm =>
      dispatch(SetNewPasswordConfirm(newPasswordConfirm))}
    onChangePasswordClick={onChangePasswordClick}
    isSubmitting={state.isSubmitting}
    currentPasswordError
    newPasswordError
    newPasswordConfirmError
    requestError={requestError}
  />
}

let default = ({userDto}: props) => {
  let user = Common_User.User.fromDto(userDto)
  renderPage(user)
}
