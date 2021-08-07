open Page_ForgotPassword_Types

let initialState = () => {
  email: "",
  reCaptcha: None,
  isSubmitting: false,
  errors: Common_User.ForgotPassword.emptyErrors(),
  attemptCount: 0,
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetErrors(errors) => {...state, errors: errors}
  | IncrementAttemptCount => {...state, attemptCount: state.attemptCount + 1}
  }
}

let renderPage = (user: option<Common_User.User.t>, clientConfig: Common_ClientConfig.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onForgotPasswordClick = _ => {
    let forgotPassword: Common_User.ForgotPassword.forgotPassword = {
      email: state.email,
      reCaptcha: state.reCaptcha,
    }

    let errors = Common_User.ForgotPassword.validateForgotPassword(forgotPassword)

    dispatch(SetErrors(errors))

    if !Common_User.ForgotPassword.hasErrors(errors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.ForgotPassword.errors = {
          ...Common_User.ForgotPassword.emptyErrors(),
          forgotPassword: Some(#RequestFailed),
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {errors} = json->Common_User.ForgotPassword.asForgotPasswordResult
        if Common_User.ForgotPassword.hasErrors(errors) {
          dispatch(SetErrors(errors))
          dispatch(SetIsSubmitting(false))
          dispatch(IncrementAttemptCount)
        } else {
          router->Next.Router.push(Common_Url.forgotPasswordSuccess())
        }
      }

      Client_User.forgotPassword(forgotPassword, onSuccess, onError)->ignore
    }
  }

  let forgotPasswordError =
    state.errors.forgotPassword->Belt.Option.map(
      Common_User.ForgotPassword.forgotPasswordErrorToString,
    )

  let emailError =
    state.errors.email->Belt.Option.map(Common_User.ForgotPassword.emailErrorToString)

  let reCaptchaError =
    state.errors.reCaptcha->Belt.Option.map(Common_User.ForgotPassword.reCaptchaErrorToString)

  <Page_ForgotPassword_View
    reCaptchaSiteKey={clientConfig.reCaptcha.siteKey}
    user={user}
    email={state.email}
    isSubmitting={state.isSubmitting}
    onEmailChange={email => dispatch(SetEmail(email))}
    onReCaptchaChange={reCaptcha => dispatch(SetReCaptcha(reCaptcha))}
    onForgotPasswordClick={onForgotPasswordClick}
    forgotPasswordError
    emailError
    reCaptchaError
    attemptCount={state.attemptCount}
  />
}

let default = ({userDto, clientConfig}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  renderPage(user, clientConfig)
}
