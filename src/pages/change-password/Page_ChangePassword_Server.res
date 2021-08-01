open Page_ChangePassword_Types

let makeResult = (user: Js.Null.t<Common_User.User.dto>) => {
  let props: props = {
    user: user,
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
  Server_Middleware.all()
  ->Server_Middleware.run(req, res)
  ->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    let commonUser = switch Belt.Option.map(currentUser, Server_User.toCommonUserDto) {
    | None => Js.Null.empty
    | Some(commonUser) => Js.Null.return(commonUser)
    }
    makeResult(commonUser)
  })
}
