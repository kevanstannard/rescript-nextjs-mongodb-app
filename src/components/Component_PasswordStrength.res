@react.component
let make = (~password: string) => {
  let score = String.length(password) == 0 ? -1 : Zxcvbn.check(password).score
  let className = switch score {
  | 0 => "w-1/5 bg-red-500"
  | 1 => "w-2/5 bg-yellow-500"
  | 2 => "w-3/5 bg-indigo-500"
  | 3 => "w-4/5 bg-blue-500"
  | 4 => "w-5/5 bg-green-500"
  | _ => "bg-gray-100 w-0"
  }
  <div className="w-full bg-gray-100 h-2"> <div className={"h-full " ++ className} /> </div>
}
