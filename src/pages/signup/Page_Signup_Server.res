open Page_Signup_Types

let makeResult = (currentUser): Next.GetServerSideProps.result<_> => {
  // If currently logged in, then redirect to home
  switch currentUser {
  | Some(_) => Server_Page.redirectHome()
  | None => {
      let props: props = {
        clientConfig: Server_Config.getClientConfig(),
      }
      Server_Page.props(props)
    }
  }
}

let getServerSideProps: Next.GetServerSideProps.t<_, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)
  })
}
