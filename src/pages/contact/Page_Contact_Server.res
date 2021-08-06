open Page_Contact_Types

let makeResult = (currentUser): Next.GetServerSideProps.result<props> => {
  let userDto = Server_User.toNullCommonUserDto(currentUser)
  let clientConfig = Server_Config.getClientConfig()
  let props: props = {
    userDto: userDto,
    clientConfig: clientConfig,
  }
  Server_Page.props(props)
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)
  })
}
