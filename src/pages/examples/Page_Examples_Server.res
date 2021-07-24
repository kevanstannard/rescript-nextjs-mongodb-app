open Page_Examples_Types

let makeResult = (): Next.GetServerSideProps.result<props> => {
  let props: props = {
    msg: "This page was rendered with getServerSideProps. You can find the source code here: ",
    href: "https://github.com/ryyppy/nextjs-default/tree/master/src/Examples.res",
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
