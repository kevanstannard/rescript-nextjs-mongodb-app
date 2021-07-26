type err

@module("../../js/load-script")
external loadScript: (. string, unit => unit, err => unit) => unit = "default"

// @module("../../js/load-script")
// external removeScript: (. string) => unit = "removeScript"

// let loadScriptPromise = (url: string): Promise.t<result<unit, string>> => {
//   Promise.make((resolve, _reject) => {
//     loadScript(
//       ~src=url,
//       ~onSuccess=() => resolve(. Ok()),
//       ~onError=_err => resolve(. Error(j`Could not load script: $url`)),
//     )->ignore
//   })
// }
