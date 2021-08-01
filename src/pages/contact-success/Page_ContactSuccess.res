open Page_ContactSuccess_Types

let default = ({user}: props) => {
  let user = Js.Null.toOption(user)->Belt.Option.map(Common_User.User.fromDto)
  <Page_ContactSuccess_View user={user} />
}
