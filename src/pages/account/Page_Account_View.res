module Title = Component_Title
module AlertMessage = Component_AlertMessage
module Link = Next.Link

module EmailChangeAlert = {
  @react.component
  let make = (~user: Common_User.User.t) => {
    switch user.emailChange {
    | None => React.null
    | Some(email) =>
      <div className="mt-4">
        <AlertMessage type_=#Info>
          <div className="font-bold"> {React.string("Pending email change")} </div>
          <div className="overflow-ellipsis overflow-hidden"> {React.string(email)} </div>
        </AlertMessage>
      </div>
    }
  }
}

@react.component
let make = (~user: Common_User.User.t) => {
  <Layout_Main user={Some(user)}>
    <Title text="Account" size=#Primary />
    <hr className="mb-6" />
    <div className="mb-6">
      <div className="font-bold"> {React.string("Email")} </div>
      <div className="overflow-ellipsis overflow-hidden"> {React.string(user.email)} </div>
      <Link href={Common_Url.changeEmail()}> {"Change email"->React.string} </Link>
      <EmailChangeAlert user={user} />
    </div>
    <hr className="mb-6" />
    <div className="mb-6">
      <div className="font-bold"> {React.string("Password")} </div>
      <Link href={Common_Url.changePassword()}> {"Change password"->React.string} </Link>
    </div>
  </Layout_Main>
}
