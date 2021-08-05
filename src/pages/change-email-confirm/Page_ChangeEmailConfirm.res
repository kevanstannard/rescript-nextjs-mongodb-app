open Page_ChangeEmailConfirm_Types

let default = ({userDto, emailChangeSuccessful}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  switch user {
  | None => <Next.Error statusCode=#Forbidden />
  | Some(user) =>
    <Page_ChangeEmailConfirm_View user={user} emailChangeSuccessful={emailChangeSuccessful} />
  }
}
