open Page_Account_Types

let makeResult = (currentUser): Next.GetServerSideProps.result<props> => {
  let currentUserDto = Server_User.toNullCommonUserDto(currentUser)
  let props: props = {
    userDto: currentUserDto,
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)
  })
}
