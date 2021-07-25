open Page_Index_Types

let useCurrentUser = () => {
  let {data} = SWR.useSWR("/api/user", Client_Fetch.getJson)
  Js.Undefined.toOption(data)
}

type user = {id: int}

let default = (props: props): React.element => {
  let {env, connected, count} = props
  let envMessage = "Env is " ++ env
  let connectedMessage = "Connected is " ++ (connected ? "true" : "false")
  let countMessage = "Count is " ++ Belt.Int.toString(count)

  let user: option<user> = useCurrentUser()

  let userMessage = switch user {
  | None => "User is not loaded"
  | Some(user) => "User id is " ++ Belt.Int.toString(user.id)
  }

  <div>
    {envMessage->React.string}
    <br />
    {connectedMessage->React.string}
    <br />
    {countMessage->React.string}
    <br />
    {userMessage->React.string}
  </div>
}
