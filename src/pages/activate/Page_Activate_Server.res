open Page_Activate_Types

let makeResult = (currentUser, activationSuccessful): Next.GetServerSideProps.result<props> => {
  let userDto = Server_User.toNullCommonUserDto(currentUser)
  let props: props = {
    userDto: userDto,
    activationSuccessful: activationSuccessful,
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, params, _> = context => {
  let {req, res, params} = context
  let {userId, activationKey} = params
  Server_Middleware.runAll(req, res)->Promise.then(_ => {
    let {client, currentUser} = Server_Middleware.getRequestData(req)
    client
    ->Server_User.activate(userId, activationKey)
    ->Promise.then(result => {
      switch result {
      | Error(_) => makeResult(currentUser, false)->Promise.resolve
      | Ok() => makeResult(currentUser, true)->Promise.resolve
      }
    })
  })
}
