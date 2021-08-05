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
  ~email,
  ~emailError,
  ~password,
  ~passwordError,
  ~isSubmitting,
  ~loginError,
  ~onEmailChange,
  ~onPasswordChange,
  ~onLoginClick,
) => {
  <Layout_Main user={None}>
    <FormContainer>
      <Title text="Login" size=#Primary />
      <ErrorMessage error={loginError} />
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
      <p>
        <Next.Link href={Common_Url.forgotPassword()}>
          {"Forgot password?"->React.string}
        </Next.Link>
      </p>
    </FormContainer>
  </Layout_Main>
}
