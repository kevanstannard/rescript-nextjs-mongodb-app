let env = Node.Process.process["env"]

let getString = (name: string): string => {
  let value = Js.Dict.get(env, name)
  switch value {
  | None => Js.Exn.raiseError("Environment variable " ++ name ++ " is missing")
  | Some(value) => value
  }
}

let getOptionString = (name: string): option<string> => {
  let value = Js.Dict.get(env, name)
  switch value {
  | None => None
  | Some(value) => {
      let value = String.trim(value)
      if String.length(value) == 0 {
        None
      } else {
        Some(value)
      }
    }
  }
}

let getInt = (name: string): int => {
  let value = getString(name)
  let valueInt = Belt.Int.fromString(value)
  switch valueInt {
  | None => Js.Exn.raiseError("Environment variable " ++ name ++ " is invalid")
  | Some(value) => value
  }
}

let getNodeEnv = () => getString("NODE_ENV")
