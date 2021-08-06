open Page_ForgotPasswordSuccess_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_ForgotPasswordSuccess_View user={user} />
}
