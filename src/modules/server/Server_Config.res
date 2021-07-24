type mongoDb = {
  uri: string,
  dbName: string,
}

type t = {mongoDb: mongoDb}

type configResult = Belt.Result.t<t, string>

let get = (): configResult => {
  open Server_Env
  try {
    let mongoDb: mongoDb = {
      uri: getString("MONGODB_URI"),
      dbName: getString("MONGODB_DB_NAME"),
    }
    let config = {
      mongoDb: mongoDb,
    }
    Ok(config)
  } catch {
  | Js.Exn.Error(error) =>
    switch Js.Exn.message(error) {
    | Some(msg) => Error(msg)
    | None => Error("Unkonwn")
    }
  | _ => Error("Unknown")
  }
}
