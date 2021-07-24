open Page_Index_Types

let default = (props: props): React.element => {
  let {env, connected, count} = props
  let envMessage = "Env is " ++ env
  let connectedMessage = "Connected is " ++ (connected ? "true" : "false")
  let countMessage = "Count is " ++ Belt.Int.toString(count)
  <div>
    {envMessage->React.string}
    <br />
    {connectedMessage->React.string}
    <br />
    {countMessage->React.string}
  </div>
}
