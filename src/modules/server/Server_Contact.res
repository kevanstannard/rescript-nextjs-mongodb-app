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

let contact = (contact: Common_Contact.contact) => {
  let errors = Common_Contact.validateContact(contact)
  if Common_Contact.hasErrors(errors) {
    Promise.resolve(Error(errors))
  } else {
    validateReCaptchaToken(contact.reCaptcha)->Promise.then(reCaptchaError => {
      let errors: Common_Contact.errors = {
        ...Common_Contact.emptyErrors(),
        reCaptcha: reCaptchaError,
      }
      if Common_Contact.hasErrors(errors) {
        Promise.resolve(Error(errors))
      } else {
        Server_Email.sendContactEmail(contact)->Promise.then(_ => {
          Promise.resolve(Ok())
        })
      }
    })
  }
}
