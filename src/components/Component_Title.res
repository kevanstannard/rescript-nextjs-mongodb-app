@react.component
let make = (~text: string, ~size: [#Primary | #Secondary], ~subtitle=?) => {
  let textClass = switch size {
  | #Secondary => "text-2xl"
  | #Primary => "text-3xl"
  }
  <div className="mb-5">
    <h1 className={"font-bold " ++ textClass}> {React.string(text)} </h1>
    {switch subtitle {
    | None => React.null
    | Some(subtitle) => <p className="text-gray-500"> {React.string(subtitle)} </p>
    }}
  </div>
}
