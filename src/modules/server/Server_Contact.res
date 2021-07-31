let validateReCaptchaToken = token => {
  switch token {
  | None => Promise.resolve(Some(#ReCaptchaEmpty))
  | Some(token) =>
    Server_ReCaptcha.verifyToken(token)->Promise.then(result => {
      switch result {
      | Error() => Promise.resolve(Some(#ReCaptchaInvalid))
      | Ok() => Promise.resolve(None)
      }
    })
  }
}

let contact = (contact: Common_Contact.contact): Promise.t<
  result<Common_Contact.validation, Common_Contact.validation>,
> => {
  let validation = Common_Contact.validateContact(contact)
  if Common_Contact.hasErrors(validation) {
    Promise.resolve(Error(validation))
  } else {
    validateReCaptchaToken(contact.reCaptcha)->Promise.then(reCaptchaError => {
      let validation: Common_Contact.validation = {
        name: None,
        email: None,
        message: None,
        reCaptcha: reCaptchaError,
      }
      if Common_Contact.hasErrors(validation) {
        Promise.resolve(Error(validation))
      } else {
        Server_Email.sendContactEmail(contact)->Promise.then(_ => {
          Promise.resolve(Ok(validation))
        })
      }
    })
  }
}
