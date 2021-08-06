open Page_ResetPassword_Types

let initialState = resetPasswordValidation => {
  password: "",
  passwordConfirm: "",
  reCaptcha: None,
  isSubmitting: false,
  errors: resetPasswordValidation,
}

let reducer = (state, action) => {
  switch action {
  | SetPassword(password) => {...state, password: password}
  | SetPasswordConfirm(passwordConfirm) => {...state, passwordConfirm: passwordConfirm}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetErrors(errors) => {...state, errors: errors}
  }
}

let default = ({userDto, userId, resetPasswordKey, resetPasswordErrorsDto, config}: props) => {
  let resetPasswordErrors =
    resetPasswordErrorsDto->Common_User.ResetPassword.dtoToResetPasswordErrors

  let user = Common_User.User.fromNullDto(userDto)

  let (state, dispatch) = React.useReducer(reducer, initialState(resetPasswordErrors))
  let router = Next.Router.useRouter()

  let onResetPasswordClick = _ => {
    let resetPassword: Common_User.ResetPassword.resetPassword = {
      userId: userId,
      resetPasswordKey: resetPasswordKey,
      password: state.password,
      passwordConfirm: state.passwordConfirm,
      reCaptcha: state.reCaptcha,
    }
    let resetPasswordErrors = Common_User.ResetPassword.validateResetPassword(resetPassword)

    dispatch(SetErrors(resetPasswordErrors))

    if !Common_User.ResetPassword.hasErrors(resetPasswordErrors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.ResetPassword.resetPasswordErrors = {
          resetPassword: Some(#RequestFailed),
          password: None,
          passwordConfirm: None,
          reCaptcha: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let resetPasswordResult = json->Common_User.ResetPassword.asResetPasswordResult
        switch resetPasswordResult.result {
        | #Ok => router->Next.Router.push(Common_Url.resetPasswordSuccess())
        | #Error => {
            let errors: Common_User.ResetPassword.resetPasswordErrors = switch resetPasswordResult.errors {
            | None => {
                resetPassword: Some(#UnknownError),
                password: None,
                passwordConfirm: None,
                reCaptcha: None,
              }
            | Some(errors) => errors // TODO: Test if any actual errors are present
            }
            dispatch(SetErrors(errors))
            dispatch(SetIsSubmitting(false))
          }
        }
      }

      let resetPassword: Common_User.ResetPassword.resetPassword = {
        userId: userId,
        resetPasswordKey: resetPasswordKey,
        password: state.password,
        passwordConfirm: state.passwordConfirm,
        reCaptcha: state.reCaptcha,
      }

      let _xhr: XmlHttpRequest.t = Client_User.resetPassword(resetPassword, onSuccess, onError)
    }
  }

  let resetPasswordError = state.errors.resetPassword

  let passwordError =
    state.errors.password->Belt.Option.map(Common_User.ResetPassword.passwordErrorToString)

  let passwordConfirmError =
    state.errors.passwordConfirm->Belt.Option.map(
      Common_User.ResetPassword.passwordConfirmErrorToString,
    )

  let reCaptchaError =
    state.errors.reCaptcha->Belt.Option.map(Common_User.ResetPassword.reCaptchaErrorToString)

  <Page_ResetPassword_View
    reCaptchaSiteKey={config.reCaptcha.siteKey}
    user={user}
    password={state.password}
    passwordConfirm={state.passwordConfirm}
    onPasswordChange={password => dispatch(SetPassword(password))}
    onPasswordConfirmChange={passwordConfirm => dispatch(SetPasswordConfirm(passwordConfirm))}
    onReCaptchaChange={reCaptcha => dispatch(SetReCaptcha(reCaptcha))}
    onResetPasswordClick={onResetPasswordClick}
    isSubmitting={state.isSubmitting}
    resetPasswordError
    passwordError
    passwordConfirmError
    reCaptchaError
  />
}
