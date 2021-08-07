open Page_ChangePassword_Types

let initialState = () => {
  currentPassword: "",
  newPassword: "",
  newPasswordConfirm: "",
  isSubmitting: false,
  errors: {
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
  | SetErrors(errors) => {...state, errors: errors}
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

    let errors = Common_User.ChangePassword.validateChangePassword(changePassword)

    dispatch(SetErrors(errors))

    if !Common_User.ChangePassword.hasErrors(errors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.ChangePassword.errors = {
          changePassword: Some(#RequestFailed),
          currentPassword: None,
          newPassword: None,
          newPasswordConfirm: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {errors} = json->Common_User.ChangePassword.asChangePasswordResult
        if Common_User.ChangePassword.hasErrors(errors) {
          dispatch(SetErrors(errors))
          dispatch(SetIsSubmitting(false))
        } else {
          router->Next.Router.push(Common_Url.changePasswordSuccess())
        }
      }

      Client_User.changePassword(changePassword, onSuccess, onError)->ignore
    }
  }

  let changePasswordError =
    state.errors.changePassword->Belt.Option.map(
      Common_User.ChangePassword.changePasswordErrorToString,
    )

  let currentPasswordError =
    state.errors.currentPassword->Belt.Option.map(
      Common_User.ChangePassword.currentPasswordErrorToString,
    )

  let newPasswordError =
    state.errors.newPassword->Belt.Option.map(Common_User.ChangePassword.newPasswordErrorToString)

  let newPasswordConfirmError =
    state.errors.newPasswordConfirm->Belt.Option.map(
      Common_User.ChangePassword.newPasswordConfirmErrorToString,
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
    changePasswordError
    currentPasswordError
    newPasswordError
    newPasswordConfirmError
  />
}

let default = ({userDto}: props) => {
  let user = Common_User.User.fromDto(userDto)
  renderPage(user)
}
