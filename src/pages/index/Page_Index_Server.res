open Page_Index_Types

let makeResult = (): Next.GetServerSideProps.result<props> => {
  let props: props = {env: Server_Env.getString("NODE_ENV")}
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = _context => {
  makeResult()->Promise.resolve
}
