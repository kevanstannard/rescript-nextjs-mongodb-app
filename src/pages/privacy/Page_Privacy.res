open Page_Privacy_Types

let default = ({userDto, html}: Page_Privacy_Types.props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_Privacy_View user={user} html={html} />
}
