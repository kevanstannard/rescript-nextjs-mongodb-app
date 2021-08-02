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

let renderPage = user => {
  let (state, dispatch) = React.useReducer(reducer, initialState())

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
        // TODO: What if `errors` contains no errors
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {result, errors} = json->Common_User.ChangeEmail.asChangeEmailResult
        switch result {
        | #Ok => Location.assign(Common_Url.changeEmailSuccess())
        | #Error => {
            dispatch(SetErrors(errors))
            dispatch(SetIsSubmitting(false))
          }
        }
      }

      let _xhr: XmlHttpRequest.t = Client_User.changeEmail(changeEmail, onSuccess, onError)
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
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  switch user {
  | None => <Next.Error statusCode=#Forbidden />
  | Some(user) => renderPage(user)
  }
}