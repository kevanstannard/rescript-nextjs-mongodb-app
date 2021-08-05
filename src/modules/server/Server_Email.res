let applicationConfig = Server_Config.get().application
let applicationName = applicationConfig.name
let applicationUrl = applicationConfig.url

let send = message => {
  let {sendGrid} = Server_Config.get()
  switch sendGrid.apiKey {
  | None => Promise.resolve()
  | Some(apiKey) => {
      SendGridMail.setApiKey(apiKey)
      SendGridMail.sendText(message)
    }
  }
}

let makeEmailAddress = (emailName, emailAddress) => `${emailName} <${emailAddress}>`

let makeUrl = path => `${applicationUrl}${path}`

let makeSubject = subject => `${applicationName} ${subject}`

let getApplicationEmail = () => {
  let {application} = Server_Config.get()
  let {emailName, emailAddress} = application
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
    to_: getApplicationEmail(),
    from: getApplicationEmail(),
    subject: `${applicationName} Error`,
    text: text,
  }
  send(message)
}

let sendContactEmail = (contact: Common_Contact.contact): Promise.t<unit> => {
  let message: SendGridMail.textMessage = {
    to_: getApplicationEmail(),
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
      `Thanks for signing up with ${applicationName}.`,
      ``,
      `Please visit the following link to activate your account:`,
      ``,
      url,
      ``,
      applicationName,
      applicationUrl,
    ]->Js.Array2.joinWith("\n")
  let message: SendGridMail.textMessage = {
    to_: userEmail,
    from: getApplicationEmail(),
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
      applicationName,
      applicationUrl,
    ]->Js.Array2.joinWith("\n")
  let message: SendGridMail.textMessage = {
    to_: userEmail,
    from: getApplicationEmail(),
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
      applicationName,
      applicationUrl,
    ]->Js.Array2.joinWith("\n")
  let message: SendGridMail.textMessage = {
    to_: userEmail,
    from: getApplicationEmail(),
    subject: makeSubject("Confirm Change Email"),
    text: text,
  }
  send(message)
}
