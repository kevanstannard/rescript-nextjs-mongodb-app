module Main = Layout_Main
module Title = Component_Title
module AlertMessage = Component_AlertMessage
module Link = Component_Link

open Component_Form
open Component_Button

module LoginError = {
  @react.component
  let make = (~error: option<Common_User.Login.loginError>, ~email) => {
    switch error {
    | None => React.null
    | Some(error) =>
      switch error {
      | #RequestFailed =>
        <AlertMessage type_=#Error>
          {"There was a problem logging you in. Please try again."->React.string}
        </AlertMessage>
      | #LoginFailed =>
        <AlertMessage type_=#Error>
          {"Your email or password is not correct."->React.string}
        </AlertMessage>
      | #AccountNotActivated => <Page_Login_Resend email />
      }
    }
  }
}

@react.component
let make = (
  ~email,
  ~emailError,
  ~password,
  ~passwordError,
  ~isSubmitting,
  ~loginError: option<Common_User.Login.loginError>,
  ~onEmailChange,
  ~onPasswordChange,
  ~onLoginClick,
) => {
  <Layout_Main user={None}>
    <FormContainer>
      <Title text="Login" size=#Primary />
      <LoginError error={loginError} email={email} />
      <TextField label="Email" value={email} onChange={onEmailChange} error={emailError} />
      <PasswordField
        label="Password"
        value={password}
        onChange={onPasswordChange}
        error={passwordError}
        showPasswordStrength=false
      />
      <Button
        color=#Green full=true onClick=onLoginClick state={isSubmitting ? #Processing : #Ready}>
        {React.string("Login")}
      </Button>
    </FormContainer>
    <p className="my-4">
      <Link href={Common_Url.forgotPassword()}> {"Forgot password?"->React.string} </Link>
    </p>
  </Layout_Main>
}
