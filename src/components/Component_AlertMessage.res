type type_ = [#Error | #Success | #Info]

@react.component
let make = (~type_: type_, ~children: React.element) => {
  let bgColor = switch type_ {
  | #Error => "bg-red-200"
  | #Success => "bg-green-200"
  | #Info => "bg-blue-200"
  }
  <div className={bgColor ++ " p-4 mb-6"}> {children} </div>
}
