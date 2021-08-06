let props = (props: 'a): Next.GetServerSideProps.result<'a> => {
  props: Some(props),
  redirect: None,
  notFound: None,
}

let redirect = (url: string): Next.GetServerSideProps.result<_> => {
  props: None,
  redirect: Some({
    destination: url,
    permanent: false,
  }),
  notFound: None,
}

let redirectHome = (): Next.GetServerSideProps.result<_> => {
  props: None,
  redirect: Some({
    destination: Common_Url.home(),
    permanent: false,
  }),
  notFound: None,
}

let redirectLogin = (): Next.GetServerSideProps.result<_> => {
  props: None,
  redirect: Some({
    destination: Common_Url.login(),
    permanent: false,
  }),
  notFound: None,
}
