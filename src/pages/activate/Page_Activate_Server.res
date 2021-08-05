open Page_Activate_Types

let makeResult = (activationSuccessful): Next.GetServerSideProps.result<props> => {
  let props: props = {
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
  let userId = MongoDb.ObjectId.fromString(userId)
  switch userId {
  | Error(_) => makeResult(false)->Promise.resolve
  | Ok(userId) =>
    Server_Middleware.runAll(req, res)->Promise.then(_ => {
      let {client, currentUser} = Server_Middleware.getRequestData(req)
      // If currently logged in then ignore activation request and redirect to home
      switch currentUser {
      | Some(_) => Server_Page.redirectHome()->Promise.resolve
      | None =>
        client
        ->Server_User.activate(userId, activationKey)
        ->Promise.then(result => {
          switch result {
          | Error(_) => makeResult(false)->Promise.resolve
          | Ok() => makeResult(true)->Promise.resolve
          }
        })
      }
    })
  }
}
