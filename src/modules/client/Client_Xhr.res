type body = Empty | Json(Js.Json.t) | FormData(Dom2.FormData.t)

let sendJson = (xhr: XmlHttpRequest.t, json: Js.Json.t) => {
  xhr->XmlHttpRequest.setRequestHeader("Content-Type", "application/json")
  xhr->XmlHttpRequest.sendString(json->Js.Json.stringify)
}

let parseJson = (xhr: XmlHttpRequest.t): result<Js.Json.t, unit> => {
  let text = xhr->XmlHttpRequest.responseText
  switch text->Js.Nullable.toOption {
  | None => Error()
  | Some(text) =>
    try {
      Ok(Js.Json.parseExn(text))
    } catch {
    | _ => Error()
    }
  }
}

let toResult = (xhr: XmlHttpRequest.t): result<Common_Http.httpResponse, unit> => {
  switch xhr->XmlHttpRequest.status {
  | 200 => xhr->parseJson->Belt.Result.map(json => Common_Http.Ok(json))
  | 400 => Common_Http.BadRequest->Ok
  | 401 => Common_Http.Unauthorized->Ok
  | 403 => Common_Http.Forbidden->Ok
  | 404 => Common_Http.NotFound->Ok
  | 500 => Common_Http.InternalServerError->Ok
  | _ => Error()
  }
}

let toCallback = (
  result: Belt.Result.t<Common_Http.httpResponse, unit>,
  onSuccess: Js.Json.t => unit,
  onError: unit => unit,
) => {
  switch result {
  | Error(_error) => onError()
  | Ok(response) =>
    switch response {
    | Ok(json) => onSuccess(json)
    | BadRequest => onError()
    | Forbidden => onError()
    | NotFound => onError()
    | Unauthorized => onError()
    | InternalServerError => onError()
    }
  }
}

let get = (~url: string, ~onSuccess: Js.Json.t => unit, ~onError: unit => unit, ()) => {
  let xhr = XmlHttpRequest.make()
  xhr->XmlHttpRequest.onError(_ => onError())
  xhr->XmlHttpRequest.onLoad(_ => xhr->toResult->toCallback(onSuccess, onError))
  xhr->XmlHttpRequest.open_(~method=#Get, ~url, ())
  xhr->XmlHttpRequest.send
  xhr
}

let post = (
  ~url: string,
  ~body: body,
  ~onSuccess: Js.Json.t => unit,
  ~onError: unit => unit,
  (),
) => {
  let xhr = XmlHttpRequest.make()
  xhr->XmlHttpRequest.onLoad(_ => xhr->toResult->toCallback(onSuccess, onError))
  xhr->XmlHttpRequest.onError(_ => onError())
  xhr->XmlHttpRequest.open_(~method=#Post, ~url, ())
  switch body {
  | Empty => xhr->XmlHttpRequest.send
  | Json(json) => xhr->sendJson(json)
  | FormData(formData) => xhr->XmlHttpRequest.sendFormData(formData)
  }
  xhr
}
