open Page_ChangeEmailConfirm_Types

let makeResult = (userDto, emailChangeSuccessful): Next.GetServerSideProps.result<props> => {
  let props: props = {
    userDto: userDto,
    emailChangeSuccessful: emailChangeSuccessful,
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, params, _> = context => {
  let {req, res, params} = context
  let {userId, emailChangeKey} = params
  let userId = MongoDb.ObjectId.fromString(userId)
  switch userId {
  | Error(_) => makeResult(Js.Null.empty, false)->Promise.resolve
  | Ok(userId) =>
    Server_Middleware.all()
    ->Server_Middleware.run(req, res)
    ->Promise.then(_ => {
      let {client, currentUser} = Server_Middleware.getRequestData(req)
      let currentUserDto = switch Belt.Option.map(currentUser, Server_User.toCommonUserDto) {
      | None => Js.Null.empty
      | Some(commonUser) => Js.Null.return(commonUser)
      }
      client
      ->Server_User.changeEmailConfirm(userId, emailChangeKey)
      ->Promise.then(result => {
        switch result {
        | Error(_) => makeResult(Js.Null.empty, false)->Promise.resolve
        | Ok() => makeResult(currentUserDto, true)->Promise.resolve
        }
      })
    })
  }
}
