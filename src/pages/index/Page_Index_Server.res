open Page_Index_Types

let makeResult = (currentUser: option<Server_User.User.t>): Next.GetServerSideProps.result<
  props,
> => {
  let userDto = Server_User.toNullCommonUserDto(currentUser)
  let props: props = {
    userDto: userDto,
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = context => {
  let {req, res} = context
  Server_Middleware.all()
  ->Server_Middleware.run(req, res)
  ->Promise.then(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)->Promise.resolve
  })
}
