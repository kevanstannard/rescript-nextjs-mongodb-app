let makeResult = (currentUser): Next.GetServerSideProps.result<_> => {
  // If currently logged in, then redirect to home
  switch currentUser {
  | Some(_) => Server_Page.redirectHome()
  | None => Server_Page.noProps()
  }
}

let getServerSideProps: Next.GetServerSideProps.t<_, _, _> = context => {
  let {req, res} = context
  Server_Middleware.runAll(req, res)->Promise.thenResolve(_ => {
    let {currentUser} = Server_Middleware.getRequestData(req)
    makeResult(currentUser)
  })
}
