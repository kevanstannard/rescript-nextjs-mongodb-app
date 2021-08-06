module Title = Component_Title
module Link = Component_Link

module ActivationSuccessful = {
  @react.component
  let make = (~user: option<Common_User.User.t>) => {
    <div>
      <Title text="Account activation successful" size=#Primary />
      <p className="mb-4"> {React.string("Your account has been activated.")} </p>
      <p className="mb-4">
        {switch user {
        | None => <Link href={Common_Url.login()}> {"Login to your account"->React.string} </Link>
        | Some(_) => <Link href={Common_Url.home()}> {"Return to home"->React.string} </Link>
        }}
      </p>
    </div>
  }
}

module ActivationFailed = {
  @react.component
  let make = () => {
    <div>
      <Title text="Account activation failed" size=#Primary />
      <p className="mb-4">
        {React.string("Sorry, there was a problem activating your account.")}
      </p>
      <p className="mb-4">
        <Link href={Common_Url.contact()}> {"Please contact us for support"->React.string} </Link>
      </p>
    </div>
  }
}

@react.component
let make = (~user: option<Common_User.User.t>, ~activationSuccessful) => {
  <Layout_Main user={user}>
    {activationSuccessful ? <ActivationSuccessful user={user} /> : <ActivationFailed />}
  </Layout_Main>
}
