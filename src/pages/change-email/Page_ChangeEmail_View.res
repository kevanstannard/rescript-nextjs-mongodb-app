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
  ~user,
  ~email,
  ~onEmailChange,
  ~onChangeEmailClick,
  ~isSubmitting,
  ~changeEmailError,
  ~emailError,
) => {
  <Layout_Main user={Some(user)}>
    <FormContainer>
      <Title text="Change Email" size=#Primary />
      <ErrorMessage error={changeEmailError} />
      <TextField
        label="New email address" value={email} onChange={onEmailChange} error={emailError}
      />
      <Button
        color=#Green
        full=true
        onClick=onChangeEmailClick
        state={isSubmitting ? #Processing : #Ready}>
        {React.string("Change Email")}
      </Button>
    </FormContainer>
  </Layout_Main>
}
