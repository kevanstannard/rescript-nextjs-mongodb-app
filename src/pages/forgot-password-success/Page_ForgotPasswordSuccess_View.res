module Title = Component_Title

@react.component
let make = (~user) => {
  <Layout_Main user={user}>
    <Title text="Forgot Password Successful" size=#Primary />
    <p className="mb-4">
      {React.string(
        "If the email address you provided exists, we will send you an email to reset your password.",
      )}
    </p>
    <p className="mb-4">
      <Next.Link href={Common_Url.home()}> {"Return to home"->React.string} </Next.Link>
    </p>
  </Layout_Main>
}
