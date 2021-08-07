open Page_Signup_Types

let getServerSideProps: Next.GetServerSideProps.t<_, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.then(_ => {
    Server_Page.withNotAuthenticated(req, () => {
      let props: props = {
        clientConfig: Server_Config.getClientConfig(),
      }
      Server_Page.props(props)->Promise.resolve
    })
  })
}
