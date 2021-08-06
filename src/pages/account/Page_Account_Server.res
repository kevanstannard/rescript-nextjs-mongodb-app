open Page_Account_Types

let makeResult = (currentUser): Next.GetServerSideProps.result<props> => {
  let currentUserDto = Server_User.toCommonUserDto(currentUser)
  let props: props = {
    userDto: currentUserDto,
  }
  Server_Page.props(props)
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.then(_ => {
    Server_Page.withAuthentication(req, currentUser => {
      makeResult(currentUser)->Promise.resolve
    })
  })
}
