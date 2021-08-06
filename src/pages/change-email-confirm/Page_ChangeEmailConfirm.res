open Page_ChangeEmailConfirm_Types

let default = ({userDto, emailChangeSuccessful}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_ChangeEmailConfirm_View user={user} emailChangeSuccessful={emailChangeSuccessful} />
}
