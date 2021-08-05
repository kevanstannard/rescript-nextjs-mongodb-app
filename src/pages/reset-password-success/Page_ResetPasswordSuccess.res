open Page_ResetPasswordSuccess_Types

let default = ({userDto}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  <Page_ResetPasswordSuccess_View user={user} />
}
