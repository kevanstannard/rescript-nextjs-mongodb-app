module Title = Component_Title
module Link = Component_Link

@react.component
let make = (~user) => {
  <Layout_Main user={user}>
    <Title text="Forgot Password Successful" size=#Primary />
    <p className="mb-4"> {React.string("We've sent you an email to reset your password.")} </p>
    <p className="mb-4">
      <Link href={Common_Url.home()}> {"Return to home"->React.string} </Link>
    </p>
  </Layout_Main>
}
