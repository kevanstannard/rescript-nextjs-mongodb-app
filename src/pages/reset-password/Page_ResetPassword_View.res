module Title = Component_Title
module AlertMessage = Component_AlertMessage
module Link = Component_Link

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

module ResetPasswordError = {
  @react.component
  let make = () => {
    <>
      <Title text="Reset Password Error" size=#Primary />
      <p className="mb-4">
        {React.string("There is a problem with your Reset Password request.")}
      </p>
      <p className="mb-4">
        <Link href={Common_Url.forgotPassword()}>
          {"Try Forgot Password again"->React.string}
        </Link>
      </p>
    </>
  }
}

module ResetPasswordInvalid = {
  @react.component
  let make = () => {
    <>
      <Title text="Reset Password Invalid" size=#Primary />
      <p className="mb-4">
        {React.string("There is a problem with your Reset Password request.")}
      </p>
      <p className="mb-4">
        <Link href={Common_Url.forgotPassword()}>
          {"Try Forgot Password again"->React.string}
        </Link>
      </p>
    </>
  }
}

module ResetPasswordExpired = {
  @react.component
  let make = () => {
    <>
      <Title text="Reset Password Expired" size=#Primary />
      <p className="mb-4">
        {React.string("The time available to reset your password has expired.")}
      </p>
      <p className="mb-4">
        <Link href={Common_Url.forgotPassword()}>
          {"Try Forgot Password again"->React.string}
        </Link>
      </p>
    </>
  }
}

module ResetPasswordAccountNotActivated = {
  @react.component
  let make = () => {
    <>
      <Title text="Reset Password Account Not Activated" size=#Primary />
      <p className="mb-4"> {React.string("Your account has not been activated yet.")} </p>
      <p className="mb-4">
        <Link href={Common_Url.forgotPassword()}>
          {"Try Forgot Password again"->React.string}
        </Link>
      </p>
    </>
  }
}
module ResetPasswordForm = {
  @react.component
  let make = (
    ~password,
    ~passwordConfirm,
    ~reCaptchaSiteKey,
    ~onPasswordChange,
    ~onPasswordConfirmChange,
    ~onReCaptchaChange,
    ~passwordError,
    ~passwordConfirmError,
    ~reCaptchaError,
    ~onResetPasswordClick,
    ~isSubmitting,
  ) => {
    <FormContainer>
      <Title text="Reset Password" size=#Primary />
      <PasswordField
        label="New password"
        value={password}
        onChange={onPasswordChange}
        error={passwordError}
        showPasswordStrength={true}
      />
      <PasswordField
        label="Confirm new password"
        value={passwordConfirm}
        onChange={onPasswordConfirmChange}
        error={passwordConfirmError}
        showPasswordStrength={false}
      />
      <ReCaptchaField
        reCaptchaSiteKey={reCaptchaSiteKey} onChange={onReCaptchaChange} error={reCaptchaError}
      />
      <div className="mb-6">
        <Button
          color=#Green
          full=true
          onClick=onResetPasswordClick
          state={isSubmitting ? #Processing : #Ready}>
          {React.string("Reset Password")}
        </Button>
      </div>
    </FormContainer>
  }
}

@react.component
let make = (
  ~user,
  ~resetPasswordError: option<Common_User.ResetPassword.resetPasswordError>,
  ~password,
  ~passwordConfirm,
  ~passwordError,
  ~passwordConfirmError,
  ~isSubmitting,
  ~onPasswordChange,
  ~onPasswordConfirmChange,
  ~onResetPasswordClick,
  ~reCaptchaSiteKey,
  ~onReCaptchaChange,
  ~reCaptchaError,
) => {
  let body = switch resetPasswordError {
  | Some(error) =>
    switch error {
    | #RequestFailed => <ResetPasswordError />
    | #ResetPasswordInvalid => <ResetPasswordInvalid />
    | #ResetPasswordExpired => <ResetPasswordExpired />
    | #AccountNotActivated => <ResetPasswordAccountNotActivated />
    }
  | None =>
    <ResetPasswordForm
      password
      passwordConfirm
      passwordError
      passwordConfirmError
      isSubmitting
      onPasswordChange
      onPasswordConfirmChange
      onResetPasswordClick
      reCaptchaSiteKey
      onReCaptchaChange
      reCaptchaError
    />
  }

  <Layout_Main user={user}> {body} </Layout_Main>
}
