open Page_Signup_Types

type user = {id: int}

let initialState = () => {
  email: "",
  password: "",
  reCaptcha: None,
  validation: {
    email: None,
    password: None,
    reCaptcha: None,
  },
  isSubmitting: false,
  signupError: None,
  signupAttemptCount: 0,
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetPassword(password) => {...state, password: password}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetValidation(validation) => {...state, validation: validation}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetSignupError(signupError) => {...state, signupError: signupError}
  | IncrementSignupAttemptCount => {...state, signupAttemptCount: state.signupAttemptCount + 1}
  }
}

// TODO: Redirect on the server if user is already logged in
let useCurrentUser = () => {
  let {data} = SWR.useSWR("/api/user", Client_Fetch.getJson)
  Js.Undefined.toOption(data)
}

let renderPage = (config: Common_ClientConfig.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())

  let onSignupClick = _ => {
    let signup: Common_User.Signup.signup = {
      email: state.email,
      password: state.password,
      reCaptcha: state.reCaptcha,
    }

    let validation = Common_User.Signup.validateSignup(signup)

    dispatch(SetSignupError(None))
    dispatch(SetValidation(validation))

    if Common_User.Signup.isValid(validation) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        dispatch(SetSignupError(Some(#RequestFailed)))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let signupResult = json->Common_User.Signup.asSignupResult
        switch signupResult.result {
        | #Ok => Common_Url.home()->Location.assign
        | #Error => {
            dispatch(SetValidation(signupResult.validation))
            dispatch(SetSignupError(None))
            dispatch(SetIsSubmitting(false))
            dispatch(IncrementSignupAttemptCount)
          }
        }
      }

      Client_User.signup(signup, onSuccess, onError)->ignore
    }
  }

  let signupError = state.signupError->Belt.Option.map(Common_User.Signup.signupErrorToString)

  let emailError = state.validation.email->Belt.Option.map(Common_User.Signup.emailErrorToString)

  let passwordError =
    state.validation.password->Belt.Option.map(Common_User.Signup.passwordErrorToString)

  let reCaptchaError =
    state.validation.reCaptcha->Belt.Option.map(Common_User.Signup.reCaptchaErrorToString)

  <Page_Signup_View
    reCaptchaSiteKey={config.reCaptcha.siteKey}
    // user={user}
    email={state.email}
    password={state.password}
    emailError={emailError}
    passwordError={passwordError}
    reCaptchaError={reCaptchaError}
    isSubmitting={state.isSubmitting}
    signupError={signupError}
    signupAttemptCount={state.signupAttemptCount}
    onEmailChange={email => dispatch(SetEmail(email))}
    onPasswordChange={password => dispatch(SetPassword(password))}
    onReCaptchaChange={password => dispatch(SetReCaptcha(password))}
    onSignupClick
  />
}

let default = ({config}: props): React.element => {
  renderPage(config)
}
