open Page_ContactSuccess_Types

let default = ({userDto}: props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_ContactSuccess_View user={user} />
}
