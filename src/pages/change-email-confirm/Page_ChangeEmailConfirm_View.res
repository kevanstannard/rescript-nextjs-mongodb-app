module Title = Component_Title

@react.component
let make = (~user: Common_User.User.t, ~emailChangeSuccessful) => {
  <Layout_Main user={Some(user)}>
    {emailChangeSuccessful
      ? <div>
          <Title text="Email change successful" size=#Primary />
          <p className="mb-4"> {React.string("Your email has been changed.")} </p>
          <p className="mb-4">
            <Next.Link href={Common_Url.home()}> {"Return to home"->React.string} </Next.Link>
          </p>
        </div>
      : <div>
          <Title text="Email change failed" size=#Primary />
          <p className="mb-4">
            {React.string("Sorry, there was a problem confirming your email change.")}
          </p>
          <p className="mb-4">
            <Next.Link href={Common_Url.contact()}>
              {"Please contact us for support"->React.string}
            </Next.Link>
          </p>
        </div>}
  </Layout_Main>
}
