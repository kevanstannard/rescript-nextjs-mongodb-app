open Page_Signup_Types

let makeResult = (): Next.GetServerSideProps.result<props> => {
  let props: props = {
    env: Server_Env.getNodeEnv(),
    config: Server_Config.getClientConfig(),
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

// let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
//   let {req, res} = context
//   Server_Middleware.all()
//   ->Server_Middleware.run(req, res)
//   ->Promise.then(_ => {
//     let {client} = Server_Middleware.getRequestData(req)

//     client
//     ->Server_User.getStats
//     ->Promise.then((stats: MongoDb.Collection.statsResult) => {
//       let {count} = stats
//       makeResult(count)->Promise.resolve

//       // let signup: Common_User.Signup.signup = {
//       //   email: "hello@example.com",
//       //   password: "abc123",
//       //   reCaptcha: None,
//       // }

//       // client
//       // ->Server_User.signupUser(signup)
//       // ->Promise.then(dbUser => {
//       //   Js.log(signup)
//       //   Js.log(dbUser)
//       //   let {count} = stats
//       //   makeResult(count)->Promise.resolve
//       // })
//     })
//   })
// }

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = _context => {
  makeResult()->Promise.resolve
}
