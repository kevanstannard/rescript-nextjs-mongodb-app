module Title = Component_Title
module Link = Component_Link

@react.component
let make = (~user) => {
  <Layout_Main user={Some(user)}>
    <Title text="Change Password Successful" size=#Primary />
    <p className="mb-4"> {React.string("Your password has been changed.")} </p>
    <p className="mb-4">
      <Link href={Common_Url.account()}> {"Return to the Account page"->React.string} </Link>
    </p>
  </Layout_Main>
}
