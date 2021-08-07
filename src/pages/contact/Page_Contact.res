open Page_Contact_Types

let initialState = (): state => {
  name: "",
  email: "",
  message: "",
  reCaptcha: None,
  errors: Common_Contact.emptyErrors(),
  isSubmitting: false,
  attemptCount: 0,
}

let reducer = (state, action) => {
  switch action {
  | SetName(name) => {...state, name: name}
  | SetEmail(email) => {...state, email: email}
  | SetMessage(message) => {...state, message: message}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetErrors(errors) => {...state, errors: errors}
  | IncrementAttemptCount => {...state, attemptCount: state.attemptCount + 1}
  }
}

let renderPage = (user: option<Common_User.User.t>, clientConfig: Common_ClientConfig.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onSendClick = _ => {
    let contact: Common_Contact.contact = {
      name: state.name,
      email: state.email,
      message: state.message,
      reCaptcha: state.reCaptcha,
    }

    let errors = Common_Contact.validateContact(contact)

    dispatch(SetErrors(errors))

    if !Common_Contact.hasErrors(errors) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        let errors: Common_Contact.errors = {
          ...Common_Contact.emptyErrors(),
          contact: Some(#RequestFailed),
        }
        dispatch(SetErrors(errors))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let {errors} = json->Common_Contact.asContactResult
        if Common_Contact.hasErrors(errors) {
          dispatch(SetErrors(errors))
          dispatch(SetIsSubmitting(false))
          dispatch(IncrementAttemptCount)
        } else {
          router->Next.Router.push(Common_Url.contactSuccess())
        }
      }

      Client_User.contact(contact, onSuccess, onError)->ignore
    }
  }

  let contactError = state.errors.contact->Belt.Option.map(Common_Contact.contactErrorToString)

  let nameError = state.errors.name->Belt.Option.map(Common_Contact.nameErrorToString)

  let emailError = state.errors.email->Belt.Option.map(Common_Contact.emailErrorToString)

  let messageError = state.errors.message->Belt.Option.map(Common_Contact.messageErrorToString)

  let reCaptchaError =
    state.errors.reCaptcha->Belt.Option.map(Common_Contact.reCaptchaErrorToString)

  <Page_Contact_View
    reCaptchaSiteKey={clientConfig.reCaptcha.siteKey}
    user={user}
    name={state.name}
    email={state.email}
    message={state.message}
    onNameChange={name => dispatch(SetName(name))}
    onEmailChange={email => dispatch(SetEmail(email))}
    onMessageChange={message => dispatch(SetMessage(message))}
    onReCaptchaChange={reCaptcha => dispatch(SetReCaptcha(reCaptcha))}
    onSendClick
    isSubmitting={state.isSubmitting}
    attemptCount={state.attemptCount}
    contactError
    nameError
    emailError
    messageError
    reCaptchaError
  />
}

let default = ({userDto, clientConfig}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  renderPage(user, clientConfig)
}
