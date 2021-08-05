open Page_Index_Types

let default = (props: props): React.element => {
  let {userDto} = props
  let user = Common_User.User.fromNullDto(userDto)
  <Page_Index_View user={user} />
}
