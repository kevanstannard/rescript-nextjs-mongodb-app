open Page_ChangeEmailSuccess_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromDto(userDto)
  <Page_ChangeEmailSuccess_View user={user} />
}
