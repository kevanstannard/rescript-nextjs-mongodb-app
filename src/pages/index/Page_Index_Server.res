open Page_Index_Types

let makeResult = (): Next.GetServerSideProps.result<props> => {
  let props: props = {env: "Testing"}
  {
    props: Some(props),
    redirect: None,
    notFound: None,
  }
}

let getServerSideProps: Next.GetServerSideProps.t<props, _, _> = _context => {
  makeResult()->Promise.resolve
}
