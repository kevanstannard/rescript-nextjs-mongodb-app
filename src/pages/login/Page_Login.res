open Page_Login_Types

type user = {id: int}

let initialState = () => {
  email: "",
  password: "",
  validation: {
    email: None,
    password: None,
  },
  isSubmitting: false,
  loginError: None,
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetPassword(password) => {...state, password: password}
  | SetValidation(validation) => {...state, validation: validation}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetLoginError(loginError) => {...state, loginError: loginError}
  }
}

// TODO: Redirect on the server if user is already logged in
let useCurrentUser = () => {
  let {data} = SWR.useSWR("/api/user", Client_Fetch.getJson)
  Js.Undefined.toOption(data)
}

let renderPage = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState())

  let onLoginClick = _ => {
    let login: Common_User.Login.login = {
      email: state.email,
      password: state.password,
    }

    let validation = Common_User.Login.validateLogin(login)

    dispatch(SetLoginError(None))
    dispatch(SetValidation(validation))

    if Common_User.Login.isValid(validation) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        dispatch(SetLoginError(Some(#RequestFailed)))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let loginResult = json->Common_User.Login.asLoginResult
        switch loginResult.result {
        | #Ok => Common_Url.home()->Location.assign
        | #Error => {
            dispatch(SetValidation(loginResult.validation))
            dispatch(SetLoginError(None))
            dispatch(SetIsSubmitting(false))
          }
        }
      }

      Client_User.login(login, onSuccess, onError)->ignore
    }
  }

  let loginError = state.loginError->Belt.Option.map(Common_User.Login.loginErrorToString)

  let emailError = state.validation.email->Belt.Option.map(Common_User.Login.emailErrorToString)

  let passwordError =
    state.validation.password->Belt.Option.map(Common_User.Login.passwordErrorToString)

  <Page_Login_View
    email={state.email}
    password={state.password}
    emailError={emailError}
    passwordError={passwordError}
    isSubmitting={state.isSubmitting}
    loginError={loginError}
    onEmailChange={email => dispatch(SetEmail(email))}
    onPasswordChange={password => dispatch(SetPassword(password))}
    onLoginClick
  />
}

let default = (_: props): React.element => {
  renderPage()
}
