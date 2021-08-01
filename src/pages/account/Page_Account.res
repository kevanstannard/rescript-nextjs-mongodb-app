open Page_Account_Types

let default = ({user}: props) => {
  let user = Js.Null.toOption(user)->Belt.Option.map(Common_User.User.fromDto)
  switch user {
  | None => <Next.Error statusCode=#Forbidden />
  | Some(user) => <Page_Account_View user={user} />
  }
}
