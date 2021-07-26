type message = {
  @as("to") to_: string,
  from: string,
  subject: string,
  text: string,
  // html: string,
}

@module("@sendgrid/mail")
external setApiKey: string => unit = "setApiKey"

@module("@sendgrid/mail")
external send: message => Js.Promise.t<unit> = "send"
