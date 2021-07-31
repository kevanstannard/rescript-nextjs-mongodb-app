let getServerSideProps: Next.GetServerSideProps.t<_, _, _> = context => {
  let {req, res} = context
  Server_Middleware.all()
  ->Server_Middleware.run(req, res)
  ->Promise.then(_ => {
    Server_Session.destroy(req)
    Promise.resolve(Server_Page.redirectHome())
  })
}
