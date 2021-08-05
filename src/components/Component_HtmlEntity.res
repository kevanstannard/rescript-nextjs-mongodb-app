@react.component
let make = (~code: string) => {
  <span dangerouslySetInnerHTML={{"__html": "&" ++ code ++ ";"}} />
}
