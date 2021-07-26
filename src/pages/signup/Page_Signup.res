open Page_Signup_Types

type user = {id: int}

let initialState = () => {
  email: "",
  password: "",
  reCaptcha: None,
  // validation: {
  //   email: None,
  //   username: None,
  //   password: None,
  //   reCaptcha: None,
  // },
  isSubmitting: false,
  // error: None,
}

let reducer = (state, action) => {
  switch action {
  | SetEmail(email) => {...state, email: email}
  | SetPassword(password) => {...state, password: password}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  // | SetError(error) => {...state, error: error}
  // | SetValidation(validation) => {...state, validation: validation}
  }
}

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
    Js.log(signup)

    // let signupValidation = Common_User.Signup.validateSignup(signup)

    // dispatch(SetError(None))
    // dispatch(SetValidation(signupValidation))

    // if !Common_User.Signup.hasErrors(signupValidation) {
    //   dispatch(SetIsSubmitting(true))

    //   let onError = () => {
    //     dispatch(SetError(Some(#RequestFailed)))
    //     dispatch(SetIsSubmitting(false))
    //   }

    //   let onSuccess = (json: Js.Json.t) => {
    //     let signupResult = json->Common_User.Signup.Decode.signupResult
    //     switch signupResult {
    //     | Ok() => Common_Url.signupSuccess()->Location.assign
    //     | Error(validation) => {
    //         dispatch(SetValidation(validation))
    //         dispatch(SetError(None))
    //         dispatch(SetIsSubmitting(false))
    //       }
    //     }
    //   }

    //   let _xhr: XmlHttpRequest.t = Client_User.signup(signup, onSuccess, onError)
    // }
  }

  // let error = switch state.error {
  // | None => None
  // | Some(_) => Some("An error occurred when trying to sign up. Please try again.")
  // }

  // let emailError =
  //   state.validation.email->Belt.Option.map(Common_User.Signup.emailValidationErrorToString)

  // let usernameError =
  //   state.validation.username->Belt.Option.map(Common_User.Signup.usernameValidationErrorToString)

  // let passwordError =
  //   state.validation.password->Belt.Option.map(Common_User.Signup.passwordValidationErrorToString)

  // let reCaptchaError =
  //   state.validation.reCaptcha->Belt.Option.map(Common_User.Signup.reCaptchaValidationErrorToString)

  <Page_Signup_View
    reCaptchaSiteKey={config.reCaptcha.siteKey}
    // user={user}
    email={state.email}
    password={state.password}
    emailError={None}
    passwordError={None}
    reCaptchaError={None}
    isSubmitting={state.isSubmitting}
    error={None}
    onEmailChange={email => dispatch(SetEmail(email))}
    onPasswordChange={password => dispatch(SetPassword(password))}
    onReCaptchaChange={password => dispatch(SetReCaptcha(password))}
    onSignupClick
  />
}

// let default = (props: props): React.element => {
//   let {
//     // env,
//     // connected,
//     // count,
//     config,
//   } = props

//   // Js.log(config)

//   // let envMessage = "Env is " ++ env
//   // let connectedMessage = "Connected is " ++ (connected ? "true" : "false")
//   // let countMessage = "Count is " ++ Belt.Int.toString(count)

//   // let user: option<user> = useCurrentUser()

//   // let userMessage = switch user {
//   // | None => "User is not loaded"
//   // | Some(user) => "User id is " ++ Belt.Int.toString(user.id)
//   // }

//   // <div>
//   //   {envMessage->React.string}
//   //   <br />
//   //   {connectedMessage->React.string}
//   //   <br />
//   //   {countMessage->React.string}
//   //   <br />
//   //   {userMessage->React.string}
//   // </div>
//   <Page_Signup_View
//     reCaptchaSiteKey={config.reCaptcha.siteKey}
//     // user={user}
//     // email={state.email}
//     email={""}
//     // password={state.password}
//     password={""}
//     emailError={None}
//     passwordError={None}
//     reCaptchaError={None}
//     // isSubmitting={state.isSubmitting}
//     isSubmitting={false}
//     // error={error}
//     error={None}
//     // onEmailChange={email => dispatch(SetEmail(email))}
//     onEmailChange={_ => ()}
//     // onPasswordChange={password => dispatch(SetPassword(password))}
//     onPasswordChange={_ => ()}
//     // onReCaptchaChange={password => dispatch(SetReCaptcha(password))}
//     onReCaptchaChange={_ => ()}
//     // onSignupClick
//     onSignupClick={_ => ()}
//   />
// }

let default = ({config}: props): React.element => {
  renderPage(config)
}
