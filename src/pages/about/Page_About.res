open Page_About_Types

let default = ({userDto, html}: Page_About_Types.props) => {
  let user = Common_User.User.fromNullDto(userDto)
  <Page_About_View user={user} html={html} />
}
