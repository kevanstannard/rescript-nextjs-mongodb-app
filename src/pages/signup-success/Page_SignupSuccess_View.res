module Title = Component_Title
module Link = Component_Link

@react.component
let make = () => {
  <Layout_Main user={None}>
    <Title text="Thanks for signing up" size=#Primary />
    <p className="mb-4">
      {React.string("We've just sent you an email to activate your account.")}
    </p>
    <p className="mb-4">
      <Link href={Common_Url.home()}> {"Return to home"->React.string} </Link>
    </p>
  </Layout_Main>
}
