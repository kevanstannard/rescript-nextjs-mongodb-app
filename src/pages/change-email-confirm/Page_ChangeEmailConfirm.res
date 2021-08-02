open Page_ChangeEmailConfirm_Types

let default = ({userDto, emailChangeSuccessful}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  switch user {
  | None => <Next.Error statusCode=#Forbidden />
  | Some(user) =>
    <Page_ChangeEmailConfirm_View user={user} emailChangeSuccessful={emailChangeSuccessful} />
  }
}
