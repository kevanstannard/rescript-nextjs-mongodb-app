open Page_ChangePasswordSuccess_Types

let makeResult = currentUser => {
  let userDto = Server_User.toCommonUserDto(currentUser)
  let props: props = {
    userDto: userDto,
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
