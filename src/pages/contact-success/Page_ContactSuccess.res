open Page_ContactSuccess_Types

let default = ({user}: props) => {
  let user = Js.Null.toOption(user)
  <Page_ContactSuccess_View user={user} />
}
