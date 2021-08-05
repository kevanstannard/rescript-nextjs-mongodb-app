open Page_ForgotPasswordSuccess_Types
let default = ({userDto}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  <Page_ForgotPasswordSuccess_View user={user} />
}
