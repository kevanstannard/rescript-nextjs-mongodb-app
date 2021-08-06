open Page_Login_Types

let initialState = () => {
  email: "",
  password: "",
  isSubmitting: false,
  errors: {
    login: None,
    email: None,
    password: None,
  },
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetPassword(password) => {...state, password: password}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetErrors(errors) => {...state, errors: errors}
  }
}

let renderPage = () => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onLoginClick = _ => {
    let login: Common_User.Login.login = {
      email: state.email,
      password: state.password,
    }

    let errors = Common_User.Login.validateLogin(login)

    dispatch(SetErrors(errors))

    if !Common_User.Login.hasErrors(errors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.Login.errors = {
          login: Some(#RequestFailed),
          email: None,
          password: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let loginResult = json->Common_User.Login.asLoginResult
        if Common_User.Login.hasErrors(loginResult.errors) {
          dispatch(SetErrors(loginResult.errors))
          dispatch(SetIsSubmitting(false))
        } else {
          let nextUrl = switch loginResult.nextUrl {
          | Some(nextUrl) => nextUrl
          | None => Common_Url.home()
          }
          router->Next.Router.push(nextUrl)
        }
      }

      Client_User.login(login, onSuccess, onError)->ignore
    }
  }

  let emailError = state.errors.email->Belt.Option.map(Common_User.Login.emailErrorToString)

  let passwordError =
    state.errors.password->Belt.Option.map(Common_User.Login.passwordErrorToString)

  <Page_Login_View
    email={state.email}
    password={state.password}
    isSubmitting={state.isSubmitting}
    onEmailChange={email => dispatch(SetEmail(email))}
    onPasswordChange={password => dispatch(SetPassword(password))}
    onLoginClick
    loginError={state.errors.login}
    emailError={emailError}
    passwordError={passwordError}
  />
}

let default = (): React.element => {
  renderPage()
}
