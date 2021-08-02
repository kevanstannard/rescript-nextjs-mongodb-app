open Page_ContactSuccess_Types

let default = ({userDto}: props) => {
  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)
  <Page_ContactSuccess_View user={user} />
}
