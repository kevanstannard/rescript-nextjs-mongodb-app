open Page_ChangeEmail_Types

let initialState = () => {
  email: "",
  isSubmitting: false,
  errors: {
    changeEmail: None,
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

let renderPage = (user: Common_User.User.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onChangeEmailClick = _ => {
    let changeEmail: Common_User.ChangeEmail.changeEmail = {
      email: state.email,
    }

    let changeEmailErrors = Common_User.ChangeEmail.validateChangeEmail(changeEmail)

    dispatch(SetErrors(changeEmailErrors))

    if !Common_User.ChangeEmail.hasErrors(changeEmailErrors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.ChangeEmail.changeEmailErrors = {
          changeEmail: Some(#RequestFailed),
          email: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {errors} = json->Common_User.ChangeEmail.asChangeEmailResult
        if Common_User.ChangeEmail.hasErrors(errors) {
          dispatch(SetErrors(errors))
          dispatch(SetIsSubmitting(false))
        } else {
          router->Next.Router.push(Common_Url.changeEmailSuccess())
        }
      }

      Client_User.changeEmail(changeEmail, onSuccess, onError)->ignore
    }
  }

  let changeEmailError =
    state.errors.changeEmail->Belt.Option.map(Common_User.ChangeEmail.changeEmailErrorToString)

  let emailError = state.errors.email->Belt.Option.map(Common_User.ChangeEmail.emailErrorToString)

  <Page_ChangeEmail_View
    user={user}
    email={state.email}
    onEmailChange={email => dispatch(SetEmail(email))}
    onChangeEmailClick={onChangeEmailClick}
    isSubmitting={state.isSubmitting}
    changeEmailError
    emailError
  />
}

let default = ({userDto}: props) => {
  let user = Common_User.User.fromDto(userDto)
  renderPage(user)
}
