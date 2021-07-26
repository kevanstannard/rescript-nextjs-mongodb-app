module Indexes = {
  let getCollection = (client: MongoDb.MongoClient.t, name: string) => {
    let db = MongoDb.MongoClient.db(client)
    MongoDb.Db.collection(db, name)
  }

  let create = (client: MongoDb.MongoClient.t) => {
    let promises = [
      client
      ->getCollection("users")
      ->MongoDb.Collection.createIndexWithOptions({"email": 1}, {"unique": true}),
    ]
    Promise.all(promises)->Promise.thenResolve(_ => ())
  }
}

// Maintain a cached connection across hot reloads in development.
// This prevents connections growing exponentially during API Route usage.
module Cache = {
  type t = Promise.t<MongoDb.MongoClient.t>
  let key = "mongodb"

  let setClientPromise = (clientPromise: t): unit => {
    Server_NodeCache.set(key, Some(clientPromise))
  }

  let getClientPromise = (): option<t> => {
    Server_NodeCache.get(key)
  }
}

let connect = (config: Server_Config.mongoDb): Promise.t<MongoDb.MongoClient.t> => {
  switch Cache.getClientPromise() {
  | Some(clientPromise) => clientPromise
  | None => {
      let options: MongoDb.connectOptions = {useUnifiedTopology: true, useNewUrlParser: true}
      let clientPromise = MongoDb.connect(config.uri, options)
      Cache.setClientPromise(clientPromise)
      clientPromise->Promise.then(Indexes.create)->Promise.then(_ => clientPromise)
    }
  }
}
