module Title = Component_Title
@react.component
let make = (~user) => {
  <Layout_Main user={Some(user)}>
    <Title text="Change Email Confirmation" size=#Primary />
    <p className="mb-4">
      {React.string("We've sent you an email to confirm your new email address.")}
    </p>
    <p className="mb-4">
      <Next.Link href={Common_Url.home()}> {"Return to home"->React.string} </Next.Link>
    </p>
  </Layout_Main>
}
