type mongoDb = {uri: string}

type t = {mongoDb: mongoDb}

let get = (): t => {
  let mongoDb: mongoDb = {
    uri: Server_Env.getString("MONGODB_URI"),
  }
  let config = {
    mongoDb: mongoDb,
  }
  config
}
