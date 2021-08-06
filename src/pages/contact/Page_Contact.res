open Page_Contact_Types

let initialState = (): state => {
  name: "",
  email: "",
  message: "",
  reCaptcha: None,
  validation: {
    name: None,
    email: None,
    message: None,
    reCaptcha: None,
  },
  isSubmitting: false,
  contactError: None,
  contactAttemptCount: 0,
}

let reducer = (state, action) => {
  switch action {
  | SetName(name) => {...state, name: name}
  | SetEmail(email) => {...state, email: email}
  | SetMessage(message) => {...state, message: message}
  | SetReCaptcha(reCaptcha) => {...state, reCaptcha: Some(reCaptcha)}
  | SetIsSubmitting(isSubmitting) => {...state, isSubmitting: isSubmitting}
  | SetContactError(contactError) => {...state, contactError: contactError}
  | SetValidation(validation) => {...state, validation: validation}
  | IncrementContactAttemptCount => {...state, contactAttemptCount: state.contactAttemptCount + 1}
  }
}

let renderPage = (user: option<Common_User.User.t>, config: Common_ClientConfig.t) => {
  let (state, dispatch) = React.useReducer(reducer, initialState())
  let router = Next.Router.useRouter()

  let onSendClick = _ => {
    let contact: Common_Contact.contact = {
      name: state.name,
      email: state.email,
      message: state.message,
      reCaptcha: state.reCaptcha,
    }

    let validation = Common_Contact.validateContact(contact)

    dispatch(SetContactError(None))
    dispatch(SetValidation(validation))

    if !Common_Contact.hasErrors(validation) {
      dispatch(SetIsSubmitting(true))

      let onError = () => {
        dispatch(SetContactError(Some(#RequestFailed)))
        dispatch(SetIsSubmitting(false))
      }

      let onSuccess = (json: Js.Json.t) => {
        let contactResult = json->Common_Contact.asContactResult
        switch contactResult.result {
        | #Ok => router->Next.Router.push(Common_Url.contactSuccess())
        | #Error => {
            dispatch(SetValidation(contactResult.validation))
            dispatch(SetContactError(None))
            dispatch(SetIsSubmitting(false))
            dispatch(IncrementContactAttemptCount)
          }
        }
      }

      let _xhr: XmlHttpRequest.t = Client_User.contact(contact, onSuccess, onError)
    }
  }

  let contactError = switch state.contactError {
  | None => None
  | Some(contactError) => {
      let text = switch contactError {
      | #RequestFailed => "An error occurred when trying to send your message. Please try again."
      | #UnknownError => "An error occurred when trying to send your message. Please try again."
      }
      Some(text)
    }
  }

  let nameError = state.validation.name->Belt.Option.map(Common_Contact.nameErrorToString)

  let emailError = state.validation.email->Belt.Option.map(Common_Contact.emailErrorToString)

  let messageError = state.validation.message->Belt.Option.map(Common_Contact.messageErrorToString)

  let reCaptchaError =
    state.validation.reCaptcha->Belt.Option.map(Common_Contact.reCaptchaErrorToString)

  <Page_Contact_View
    reCaptchaSiteKey={config.reCaptcha.siteKey}
    user={user}
    name={state.name}
    email={state.email}
    message={state.message}
    onNameChange={name => dispatch(SetName(name))}
    onEmailChange={email => dispatch(SetEmail(email))}
    onMessageChange={message => dispatch(SetMessage(message))}
    onReCaptchaChange={reCaptcha => dispatch(SetReCaptcha(reCaptcha))}
    nameError
    emailError
    messageError
    reCaptchaError
    onSendClick
    isSubmitting={state.isSubmitting}
    contactError={contactError}
    contactAttemptCount={state.contactAttemptCount}
  />
}

let default = ({userDto, config}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  renderPage(user, config)
}
