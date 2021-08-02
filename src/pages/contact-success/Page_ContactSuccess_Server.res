open Page_ContactSuccess_Types

let makeResult = (userDto): Next.GetServerSideProps.result<props> => {
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
    let commonUser = switch Belt.Option.map(currentUser, Server_User.toCommonUserDto) {
    | None => Js.Null.empty
    | Some(commonUser) => Js.Null.return(commonUser)
    }
    makeResult(commonUser)->Promise.resolve
  })
}
