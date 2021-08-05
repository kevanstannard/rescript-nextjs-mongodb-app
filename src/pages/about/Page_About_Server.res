open Page_About_Types

let makeResult = (
  currentUser: option<Server_User.User.t>,
  html: string,
): Next.GetServerSideProps.result<props> => {
  let userDto = Server_User.toNullCommonUserDto(currentUser)
  let props: props = {
    userDto: userDto,
    html: html,
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
    let html = Marked.parse(Page_About_Markdown.markdown)
    makeResult(currentUser, html)->Promise.resolve
  })
}
