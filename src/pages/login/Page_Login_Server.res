let makeResult = (currentUser: option<Server_User.User.t>): Next.GetServerSideProps.result<_> => {
  // If currently logged in, then redirect to home
  switch currentUser {
  | Some(_) => Server_Page.redirectHome()
  | None => {
      props: Some(Js.Obj.empty()),
      redirect: None,
      notFound: None,
    }
  }
}

let getServerSideProps: Next.GetServerSideProps.t<_, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)
  })
}
