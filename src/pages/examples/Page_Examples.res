open Page_Examples_Types

let default = (props: props): React.element => {
  let {msg, href} = props
  <div>
    {React.string(msg)} <a href target="_blank"> {React.string("`src/Examples.res`")} </a>
  </div>
}
