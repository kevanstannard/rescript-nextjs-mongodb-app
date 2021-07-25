open Page_Index_Types

let makeResult = (count: int): Next.GetServerSideProps.result<props> => {
  let props: props = {
    env: Server_Env.getString("NODE_ENV"),
    connected: true,
    count: count,
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
  let {req, res} = context
  Server_Middleware.all()
  ->Server_Middleware.run(req, res)
  ->Promise.then(_ => {
    let {client} = Server_Middleware.getRequestData(req)

    client
    ->Server_User.getStats
    ->Promise.then((stats: MongoDb.Collection.statsResult) => {
      let signup: Common_User.Signup.signup = {
        email: "hello@example.com",
        password: "abc123",
        reCaptcha: None,
      }

      client
      ->Server_User.signupUser(signup)
      ->Promise.then(dbUser => {
        Js.log(signup)
        Js.log(dbUser)
        let {count} = stats
        makeResult(count)->Promise.resolve
      })
    })
  })
}
