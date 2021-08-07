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
  ~currentPassword,
  ~newPassword,
  ~newPasswordConfirm,
  ~onCurrentPasswordChange,
  ~onNewPasswordChange,
  ~onNewPasswordConfirmChange,
  ~onChangePasswordClick,
  ~isSubmitting,
  ~changePasswordError,
  ~currentPasswordError,
  ~newPasswordError,
  ~newPasswordConfirmError,
) => {
  <Layout_Main user={Some(user)}>
    <FormContainer>
      <Title text="Change Password" size=#Primary />
      <ErrorMessage error={changePasswordError} />
      <PasswordField
        label="Current password"
        value={currentPassword}
        onChange={onCurrentPasswordChange}
        error={currentPasswordError}
        showPasswordStrength={false}
      />
      <PasswordField
        label="New password"
        value={newPassword}
        onChange={onNewPasswordChange}
        error={newPasswordError}
        showPasswordStrength={true}
      />
      <PasswordField
        label="Confirm new password"
        value={newPasswordConfirm}
        onChange={onNewPasswordConfirmChange}
        error={newPasswordConfirmError}
        showPasswordStrength={false}
      />
      <div className="mb-6">
        <Button
          color=#Green
          full=true
          onClick=onChangePasswordClick
          state={isSubmitting ? #Processing : #Ready}>
          {React.string("Change Password")}
        </Button>
      </div>
    </FormContainer>
  </Layout_Main>
}
