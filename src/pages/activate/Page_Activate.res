open Page_Activate_Types

let default = ({userDto, activationSuccessful}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_Activate_View user={user} activationSuccessful={activationSuccessful} />
}
