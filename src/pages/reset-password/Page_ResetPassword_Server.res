open Page_ResetPassword_Types

let getServerSideProps: Next.GetServerSideProps.t<props, params, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.then(_ => {
    let {req, params} = context
    let {currentUser, client} = Server_Middleware.getRequestData(req)
    let {userId, resetPasswordKey}: params = params
    let clientConfig = Server_Config.getClientConfig()

    let currentUserDto = Server_User.toNullCommonUserDto(currentUser)

    Server_User.validateResetPasswordKey(
      client,
      userId,
      resetPasswordKey,
    )->Promise.then(validationResult => {
      let resetPasswordError = switch validationResult {
      | Error(error) => {
          let resetPasswordError = Common_User.ResetPassword.refineResetPasswordKeyError(error)
          Some(resetPasswordError)
        }
      | Ok() => None
      }

      let resetPasswordErrors: Common_User.ResetPassword.resetPasswordErrors = {
        resetPassword: resetPasswordError,
        password: None,
        passwordConfirm: None,
        reCaptcha: None,
      }

      let props: Page_ResetPassword_Types.props = {
        config: clientConfig,
        userDto: currentUserDto,
        userId: userId,
        resetPasswordKey: resetPasswordKey,
        resetPasswordErrorsDto: resetPasswordErrors->Common_User.ResetPassword.resetPasswordErrorsToDto,
      }

      Server_Page.props(props)->Promise.resolve
    })
  })
}
