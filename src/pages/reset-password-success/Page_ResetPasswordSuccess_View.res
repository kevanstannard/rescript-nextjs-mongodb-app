module Title = Component_Title

@react.component
let make = (~user) => {
  <Layout_Main user={user}>
    <Title text="Reset Password Successful" size=#Primary />
    <p className="mb-4"> {React.string("Your password has been reset.")} </p>
    <p className="mb-4">
      <Next.Link href={Common_Url.login()}> {"Return to login"->React.string} </Next.Link>
    </p>
  </Layout_Main>
}
