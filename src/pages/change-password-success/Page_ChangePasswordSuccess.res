open Page_ChangePasswordSuccess_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromDto(userDto)
  <Page_ChangePasswordSuccess_View user={user} />
}
