open Page_Signup_Types

let makeResult = (): Next.GetServerSideProps.result<props> => {
  let props: props = {
    env: Server_Env.getNodeEnv(),
    config: Server_Config.getClientConfig(),
  }
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = _context => {
  makeResult()->Promise.resolve
}
