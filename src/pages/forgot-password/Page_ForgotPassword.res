open Page_ForgotPassword_Types

let initialState = () => {
  email: "",
  isSubmitting: false,
  errors: {
    forgotPassword: None,
    email: None,
  },
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetErrors(errors) => {...state, errors: errors}
  }
}

let renderPage = (user: option<Common_User.User.t>) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onForgotPasswordClick = _ => {
    let forgotPassword: Common_User.ForgotPassword.forgotPassword = {
      email: state.email,
    }

    let forgotPasswordErrors = Common_User.ForgotPassword.validateForgotPassword(forgotPassword)

    dispatch(SetErrors(forgotPasswordErrors))

    if !Common_User.ForgotPassword.hasErrors(forgotPasswordErrors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.ForgotPassword.errors = {
          forgotPassword: Some(#RequestFailed),
          email: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {errors} = json->Common_User.ForgotPassword.asForgotPasswordResult
        if Common_User.ForgotPassword.hasErrors(errors) {
          dispatch(SetErrors(errors))
          dispatch(SetIsSubmitting(false))
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

  <Page_ForgotPassword_View
    user={user}
    email={state.email}
    isSubmitting={state.isSubmitting}
    onEmailChange={email => dispatch(SetEmail(email))}
    onForgotPasswordClick={onForgotPasswordClick}
    forgotPasswordError
    emailError
  />
}

let default = ({userDto}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  renderPage(user)
}
