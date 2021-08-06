open Page_ResetPasswordSuccess_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_ResetPasswordSuccess_View user={user} />
}
