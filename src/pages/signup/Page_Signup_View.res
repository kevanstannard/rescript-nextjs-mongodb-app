module Main = Layout_Main
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
  ~email,
  ~emailError,
  ~password,
  ~passwordError,
  ~reCaptchaError,
  ~isSubmitting,
  ~error,
  ~onEmailChange,
  ~onPasswordChange,
  ~onReCaptchaChange,
  ~onSignupClick,
) => {
  <FormContainer>
    <Title text="Sign Up" size=#Primary />
    <ErrorMessage error />
    <TextField label="Email" value={email} onChange={onEmailChange} error={emailError} />
    <PasswordField
      label="Password"
      value={password}
      onChange={onPasswordChange}
      error={passwordError}
      showPasswordStrength=true
    />
    <ReCaptchaField
      reCaptchaSiteKey={reCaptchaSiteKey} onChange={onReCaptchaChange} error={reCaptchaError}
    />
    <Button
      color=#Green full=true onClick=onSignupClick state={isSubmitting ? #Processing : #Ready}>
      {React.string("Sign Up")}
    </Button>
  </FormContainer>
}
