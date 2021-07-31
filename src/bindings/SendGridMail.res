type textMessage = {
  @as("to") to_: string,
  from: string,
  subject: string,
  text: string,
}

type htmlMessage = {
  @as("to") to_: string,
  from: string,
  subject: string,
  text: string,
  html: string,
}

@module("@sendgrid/mail")
external setApiKey: string => unit = "setApiKey"

@module("@sendgrid/mail")
external sendText: textMessage => Js.Promise.t<unit> = "send"

@module("@sendgrid/mail")
external sendHtml: htmlMessage => Js.Promise.t<unit> = "send"
