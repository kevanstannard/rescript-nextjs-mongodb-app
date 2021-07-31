let send = message => {
  let config = Server_Config.get()
  SendGridMail.setApiKey(config.sendGrid.apiKey)
  SendGridMail.sendText(message)
}

let getSystemName = () => "ReScript NextJS MongoDB App"

// Omit the trailing slash
let getSystemUrl = () => "https://rescript-nextjs-mongodb-app.vercel.app"

let makeEmailAddress = (emailName, emailAddress) => `${emailName} <${emailAddress}>`

let makeUrl = path => `${getSystemUrl()}${path}`

let makeSubject = subject => `${getSystemName()} ${subject}`

let getSystemEmail = () => {
  let {system} = Server_Config.get()
  let {emailName, emailAddress} = system
  makeEmailAddress(emailName, emailAddress)
}

let errorToString = (error: Js.Exn.t) => {
  let name = error->Js.Exn.name->Belt.Option.getWithDefault("Unknown")
  let stack = error->Js.Exn.stack->Belt.Option.getWithDefault("Unknown")
  let text = [name, stack]->Js.Array2.joinWith("\n\n")
  text
}

let unknownExnToString = (exn: exn) => {
  // Could be a ReScript exception
  let json = try {
    Js.Json.stringifyAny(exn)
  } catch {
  | _ => None
  }
  switch json {
  | Some(json) => json
  | None => "Unknown"
  }
}

let exnToString = (exn: exn) => {
  switch exn {
  | Promise.JsError(error) => errorToString(error)
  | Js.Exn.Error(error) => errorToString(error)
  | exn => unknownExnToString(exn)
  }
}

let sendExceptionEmail = (userEmail: option<string>, url: string, exn: exn): Promise.t<unit> => {
  let email = Belt.Option.getWithDefault(userEmail, "Unknown")
  let time = "Time: " ++ Js.Date.make()->Js.Date.toISOString
  let user = "User: " ++ email
  let url = "URL: " ++ url
  let exnText = exnToString(exn)
  let text = [time, user, url, exnText]->Js.Array2.joinWith("\n\n")
  let message: SendGridMail.textMessage = {
    to_: getSystemEmail(),
    from: getSystemEmail(),
    subject: `${getSystemName()} Error`,
    text: text,
  }
  send(message)
}

let sendContactEmail = (contact: Common_Contact.contact): Promise.t<unit> => {
  let message: SendGridMail.textMessage = {
    to_: getSystemEmail(),
    from: makeEmailAddress(contact.name, contact.email),
    subject: makeSubject("Contact"),
    text: contact.message,
  }
  send(message)
}

let sendActivationEmail = (userId: string, userEmail: string, activationKey: string): Promise.t<
  unit,
> => {
  let url = Common_Url.activate(userId, activationKey)->makeUrl
  let text =
    [
      `Thanks for signing up with ${getSystemName()}.`,
      ``,
      `Please visit the following link to activate your account:`,
      ``,
      url,
      ``,
      getSystemName(),
      getSystemUrl(),
    ]->Js.Array2.joinWith("\n")
  let message: SendGridMail.textMessage = {
    to_: userEmail,
    from: getSystemEmail(),
    subject: makeSubject("Activation"),
    text: text,
  }
  send(message)
}

let sendForgotPasswordEmail = (userId, userEmail, resetPasswordKey): Promise.t<unit> => {
  let url = Common_Url.resetPassword(userId, resetPasswordKey)->makeUrl
  let text =
    [
      "We've received a request to reset your password.",
      "",
      "If you did not make this request, you can safely ignore this email.",
      "",
      "Otherwise, please visit the following link to reset your password.",
      "",
      url,
      "",
      getSystemName(),
      getSystemUrl(),
    ]->Js.Array2.joinWith("\n")
  let message: SendGridMail.textMessage = {
    to_: userEmail,
    from: getSystemEmail(),
    subject: makeSubject("Reset Password"),
    text: text,
  }
  send(message)
}

let sendEmailChangeEmail = (userId, userEmail, emailChangeKey): Promise.t<unit> => {
  let url = Common_Url.changeEmailConfirm(userId, emailChangeKey)->makeUrl
  let text =
    [
      "We've received a request to change your email address.",
      "",
      "Please visit the following link to confirm your new email address.",
      "",
      url,
      "",
      getSystemName(),
      getSystemUrl(),
    ]->Js.Array2.joinWith("\n")
  let message: SendGridMail.textMessage = {
    to_: userEmail,
    from: getSystemEmail(),
    subject: makeSubject("Confirm Change Email"),
    text: text,
  }
  send(message)
}
