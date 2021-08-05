open Page_ResetPassword_Types

let makeResult = (context: Next.GetServerSideProps.context<props, params, _>) => {
  let {req, params} = context
  let {currentUser, client} = Server_Middleware.getRequestData(req)
  let {userId, resetPasswordKey}: params = params
  let clientConfig = Server_Config.getClientConfig()

  let currentUserDto = switch Belt.Option.map(currentUser, Server_User.toCommonUserDto) {
  | None => Js.Null.empty
  | Some(currentUserDto) => Js.Null.return(currentUserDto)
  }

  Server_User.validateResetPasswordKey(
    client,
    userId,
    resetPasswordKey,
  )->Promise.then(validationResult => {
    let resetPasswordErrors: Common_User.ResetPassword.resetPasswordErrors = switch validationResult {
    | Error(error) => {
        let resetPasswordError = Common_User.ResetPassword.refineResetPasswordKeyError(error)
        {
          resetPassword: Some(resetPasswordError),
          password: None,
          passwordConfirm: None,
          reCaptcha: None,
        }
      }
    | Ok(_) => {
        resetPassword: None,
        password: None,
        passwordConfirm: None,
        reCaptcha: None,
      }
    }
    let props: Page_ResetPassword_Types.props = {
      config: clientConfig,
      userDto: currentUserDto,
      userId: userId,
      resetPasswordKey: resetPasswordKey,
      resetPasswordErrorsDto: resetPasswordErrors->Common_User.ResetPassword.resetPasswordErrorsToDto,
    }
    let result: Next.GetServerSideProps.result<props> = {
      props: Some(props),
      redirect: None,
      notFound: None,
    }
    Promise.resolve(result)
  })
}

let getServerSideProps: Next.GetServerSideProps.t<props, params, _> = context => {
  let {req, res} = context
  Server_Middleware.all()
  ->Server_Middleware.run(req, res)
  ->Promise.then(_ => {
    makeResult(context)
  })
}
