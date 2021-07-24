open Page_Index_Types

let default = (props: props): React.element => {
  let {env} = props
  <div> {"Env is "->React.string} {env->React.string} </div>
}
