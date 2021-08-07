let getServerSideProps: Next.GetServerSideProps.t<_, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.then(_ => {
    Server_Page.withNotAuthenticated(req, () => {
      Server_Page.noProps()->Promise.resolve
    })
  })
}
