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
  Server_Middleware.defaultMiddleware()
  ->Server_Middleware.run(req, res)
  ->Promise.then(_ => {
    let {client} = Server_Middleware.getRequestData(req)
    client
    ->Server_Test.getStats
    ->Promise.then((stats: MongoDb.Collection.statsResult) => {
      let {count} = stats
      makeResult(count)->Promise.resolve
    })
  })
}
