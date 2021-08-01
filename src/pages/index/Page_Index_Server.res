open Page_Index_Types

let makeResult = (
  stats: MongoDb.Collection.statsResult,
  user: Js.Null.t<Common_User.User.dto>,
): Next.GetServerSideProps.result<props> => {
  let props: props = {
    env: Server_Env.getString("NODE_ENV"),
    count: stats.count,
    user: user,
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
    let {client, user} = Server_Middleware.getRequestData(req)
    let commonUser = switch Belt.Option.map(user, Server_User.toCommonUserDto) {
    | None => Js.Null.empty
    | Some(commonUser) => Js.Null.return(commonUser)
    }
    client
    ->Server_Test.getStats
    ->Promise.then((stats: MongoDb.Collection.statsResult) => {
      makeResult(stats, commonUser)->Promise.resolve
    })
  })
}
