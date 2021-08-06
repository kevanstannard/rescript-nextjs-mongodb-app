open Page_Account_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromDto(userDto)
  <Page_Account_View user={user} />
}
