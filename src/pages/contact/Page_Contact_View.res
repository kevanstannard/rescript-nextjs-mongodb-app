module Title = Component_Title
module AlertMessage = Component_AlertMessage

open Component_Form
open Component_Button

module ErrorMessage = {
  @react.component
  let make = (~error) => {
    switch error {
    | Some(error) => <AlertMessage type_=#Error> {React.string(error)} </AlertMessage>
    | None => React.null
    }
  }
}

@react.component
let make = (
  ~reCaptchaSiteKey,
  ~user,
  ~name,
  ~email,
  ~message,
  ~onNameChange,
  ~onEmailChange,
  ~onMessageChange,
  ~onReCaptchaChange,
  ~nameError,
  ~emailError,
  ~messageError,
  ~reCaptchaError,
  ~onSendClick,
  ~isSubmitting,
  ~contactError,
  ~contactAttemptCount,
) => {
  <Layout_Main user={user}>
    <FormContainer>
      <Title text="Contact Us" size=#Primary />
      <ErrorMessage error={contactError} />
      <TextField label="Your name" value={name} onChange={onNameChange} error={nameError} />
      <TextField label="Your email" value={email} onChange={onEmailChange} error={emailError} />
      <TextAreaField
        label="Your message" value={message} onChange={onMessageChange} error={messageError}
      />
      <ReCaptchaField
        key={"recaptcha-" ++ Belt.Int.toString(contactAttemptCount)}
        reCaptchaSiteKey={reCaptchaSiteKey}
        onChange={onReCaptchaChange}
        error={reCaptchaError}
      />
      <Button
        color=#Green full=true onClick=onSendClick state={isSubmitting ? #Processing : #Ready}>
        {React.string("Send")}
      </Button>
    </FormContainer>
  </Layout_Main>
}
