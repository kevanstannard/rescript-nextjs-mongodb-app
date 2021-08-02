open Page_Index_Types

// let useCurrentUser = () => {
//   let {data} = SWR.useSWR("/api/user", Client_Fetch.getJson)
//   Js.Undefined.toOption(data)
// }
// let user: option<user> = useCurrentUser()

type user = {id: int}

let default = (props: props): React.element => {
  let {env, count, userDto} = props
  let envMessage = "Env is " ++ env
  let countMessage = "Count is " ++ Belt.Int.toString(count)

  let user = Js.Null.toOption(userDto)->Belt.Option.map(Common_User.User.fromDto)

  let userMessage = switch user {
  | None => "None"
  | Some(user) => "User id is " ++ user.id
  }

  <Layout_Main user={user}>
    {envMessage->React.string}
    <br />
    {userMessage->React.string}
    <br />
    {countMessage->React.string}
  </Layout_Main>
}
