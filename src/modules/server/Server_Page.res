open Next.GetServerSideProps

let redirect = url => {
  props: None,
  redirect: Some({
    destination: url,
    permanent: false,
  }),
  notFound: None,
}

let redirectHome = () => {
  props: None,
  redirect: Some({
    destination: Common_Url.home(),
    permanent: false,
  }),
  notFound: None,
}

let redirectLogin = () => {
  props: None,
  redirect: Some({
    destination: Common_Url.login(),
    permanent: false,
  }),
  notFound: None,
}
