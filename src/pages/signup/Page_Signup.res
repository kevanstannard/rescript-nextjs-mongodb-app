open Page_Signup_Types

let initialState = (): state => {
  email: "",
  password: "",
  reCaptcha: None,
  isSubmitting: false,
  signupAttemptCount: 0,
  errors: {
    signup: None,
    email: None,
    password: None,
    reCaptcha: None,
  },
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetPassword(password) => {...state, password: password}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | IncrementSignupAttemptCount => {...state, signupAttemptCount: state.signupAttemptCount + 1}
  | SetErrors(errors) => {...state, errors: errors}
  }
}

let renderPage = (clientConfig: Common_ClientConfig.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onSignupClick = _ => {
    let signup: Common_User.Signup.signup = {
      email: state.email,
      password: state.password,
      reCaptcha: state.reCaptcha,
    }

    let errors = Common_User.Signup.validateSignup(signup)

    dispatch(SetErrors(errors))

    if !Common_User.Signup.hasErrors(errors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_User.Signup.errors = {
          signup: Some(#RequestFailed),
          email: None,
          password: None,
          reCaptcha: None,
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {errors} = json->Common_User.Signup.asSignupResult
        if Common_User.Signup.hasErrors(errors) {
          dispatch(SetErrors(errors))
          dispatch(SetIsSubmitting(false))
          dispatch(IncrementSignupAttemptCount)
        } else {
          router->Next.Router.push(Common_Url.signupSuccess())
        }
      }

      Client_User.signup(signup, onSuccess, onError)->ignore
    }
  }

  let signupError = state.errors.signup->Belt.Option.map(Common_User.Signup.signupErrorToString)

  let emailError = state.errors.email->Belt.Option.map(Common_User.Signup.emailErrorToString)

  let passwordError =
    state.errors.password->Belt.Option.map(Common_User.Signup.passwordErrorToString)

  let reCaptchaError =
    state.errors.reCaptcha->Belt.Option.map(Common_User.Signup.reCaptchaErrorToString)

  <Page_Signup_View
    reCaptchaSiteKey={clientConfig.reCaptcha.siteKey}
    email={state.email}
    password={state.password}
    isSubmitting={state.isSubmitting}
    signupAttemptCount={state.signupAttemptCount}
    onEmailChange={email => dispatch(SetEmail(email))}
    onPasswordChange={password => dispatch(SetPassword(password))}
    onReCaptchaChange={password => dispatch(SetReCaptcha(password))}
    onSignupClick
    signupError
    emailError
    passwordError
    reCaptchaError
  />
}

let default = ({clientConfig}: props): React.element => {
  renderPage(clientConfig)
}
