open MongoDb

let getCollection = (client: MongoClient.t) => {
  let db = MongoClient.db(client)
  Db.collection(db, "test")
}

let getStats = (client: MongoClient.t) => {
  getCollection(client)->Collection.stats
}
