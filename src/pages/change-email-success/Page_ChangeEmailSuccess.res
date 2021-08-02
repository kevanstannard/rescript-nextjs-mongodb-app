open Page_ChangeEmailSuccess_Types

let default = ({userDto}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  switch user {
  | None => <Next.Error statusCode=#Forbidden />
  | Some(user) => <Page_ChangeEmailSuccess_View user={user} />
  }
}