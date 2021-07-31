module Title = Component_Title
module Link = Next.Link

@react.component
let make = (~user) => {
  <Layout_Main user={user}>
    <Title text="Thanks for getting in touch" size=#Primary />
    <p className="mb-4"> {React.string("Your message has been sent.")} </p>
    <p className="mb-4">
      <Link href={Common_Url.home()}> {"Return to home"->React.string} </Link>
    </p>
  </Layout_Main>
}
