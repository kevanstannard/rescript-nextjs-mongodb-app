open Page_ChangePasswordSuccess_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  switch user {
  | None => <Component_Error403 />
  | Some(user) => <Page_ChangePasswordSuccess_View user={user} />
  }
}
