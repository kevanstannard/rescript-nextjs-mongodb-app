type method = [#get | #post]
type fetchResponse

@module("node-fetch") @val external fetch_: (string, {..}) => Promise.t<fetchResponse> = "fetch"
@send external json: fetchResponse => Promise.t<'a> = "json"

// external asJson: 'a => Js.Json.t = "%identity"

let fetchJson = (url: string, method: method) => {
  let options = {"method": method}
  fetch_(url, options)->Promise.then(json)
}

let postJson = (url: string) => fetchJson(url, #post)
