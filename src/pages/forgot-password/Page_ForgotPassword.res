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
        let errors: Common_User.ForgotPassword.forgotPasswordErrors = {
          forgotPassword: Some(#RequestFailed),
          email: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let forgotPasswordResult = json->Common_User.ForgotPassword.asForgotPasswordResult
        switch forgotPasswordResult.result {
        | #Ok => router->Next.Router.push(Common_Url.forgotPasswordSuccess())
        | #Error => {
            let errors: Common_User.ForgotPassword.forgotPasswordErrors = switch forgotPasswordResult.errors {
            | None => {
                forgotPassword: Some(#UnknownError),
                email: None,
              }
            | Some(errors) => errors
            }
            dispatch(SetErrors(errors))
            dispatch(SetIsSubmitting(false))
          }
        }
      }

      let _xhr: XmlHttpRequest.t = Client_User.forgotPassword(forgotPassword, onSuccess, onError)
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
    forgotPasswordError={forgotPasswordError}
    email={state.email}
    emailError
    isSubmitting={state.isSubmitting}
    onEmailChange={email => dispatch(SetEmail(email))}
    onForgotPasswordClick={onForgotPasswordClick}
  />
}

let default = ({userDto}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  renderPage(user)
}
