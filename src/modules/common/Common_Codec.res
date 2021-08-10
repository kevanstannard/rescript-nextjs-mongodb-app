let isDate: Js.Json.t => bool = %raw(`
  function isDate(o) {
    return o instanceof Date;
  }
`)

external dateToJson: Js.Date.t => Js.Json.t = "%identity"
external jsonToDate: Js.Json.t => Js.Date.t = "%identity"

let encodeDate = dateToJson

let decodeDate = (json: Js.Json.t): result<Js.Date.t, Js.Json.t> => {
  if isDate(json) {
    Ok(jsonToDate(json))
  } else {
    Error(json)
  }
}

let dateCodec = Jzon.custom(
  date => encodeDate(date),
  json => {
    switch json->decodeDate {
    | Ok(date) => Ok(date)
    | Error(json) => Error(#UnexpectedJsonType([], "date", json))
    }
  },
)

let dateStringCodec = Jzon.custom(
  date => date->DateFns.formatISO->Js.Json.string,
  json => {
    let dateString = Js.Json.decodeString(json)
    switch dateString {
    | None => Error(#UnexpectedJsonType([], "string", json))
    | Some(dateString) => {
        let date = DateFns.parseISO(dateString)
        if Common_Date.isInvalidDate(date) {
          Error(#UnexpectedJsonValue([], dateString))
        } else {
          Ok(date)
        }
      }
    }
  },
)

let encodeDateString = date => dateStringCodec->Jzon.encode(date)

let decodeDateString = dateString => {
  let date = dateStringCodec->Jzon.decode(dateString)
  switch date {
  | Ok(date) => Ok(date)
  | Error(reason) => Error(Jzon.DecodingError.toString(reason))
  }
}

let decodeWithErrorAsString = (codec, json: Js.Json.t) => {
  switch codec->Jzon.decode(json) {
  | Ok(result) => Ok(result)
  | Error(reason) => Error(reason->Jzon.DecodingError.toString)
  }
}
