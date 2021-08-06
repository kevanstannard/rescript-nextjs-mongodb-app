open Page_ChangeEmailSuccess_Types

let makeResult = (currentUser: option<Server_User.User.t>) => {
  let userDto = Server_User.toNullCommonUserDto(currentUser)
  let props: props = {
    userDto: userDto,
  }
  let result: Next.GetServerSideProps.result<props> = {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
  result
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)
  })
}
