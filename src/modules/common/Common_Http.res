type httpResponse =
  | Ok(Js.Json.t)
  | BadRequest
  | Forbidden
  | NotFound
  | Unauthorized
  | InternalServerError
