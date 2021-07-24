module ObjectID = {
  type t

  @module("mongodb") @scope("ObjectID")
  external isValid: 'a => bool = "isValid"

  // Unsafe because it can throw a runtime error
  @module("mongodb") @scope("ObjectID")
  external createFromHexString_UNSAFE: string => t = "createFromHexString"

  let createFromHexString = value => {
    try {
      Some(createFromHexString_UNSAFE(value))
    } catch {
    | _ => None
    }
  }

  @send
  external toHexString: t => string = "toHexString"

  @module("mongodb") @new
  external make: unit => t = "ObjectID"

  let makeAsString = (): string => make()->toHexString
}

module Cursor = {
  type t

  @send
  external close: t => t = "close"

  @send
  external limit: (t, int) => t = "limit"

  @send
  external sort: (t, {..}) => t = "sort"

  @send
  external toArray: t => Js.Promise.t<Js.Json.t> = "toArray"
}

module Collection = {
  type t

  type statsResult = {
    ns: string,
    size: int,
    count: int,
    storageSize: int,
  }

  type insertOneResult = {
    insertedCount: int,
    insertedId: ObjectID.t,
    ops: array<Js.Json.t>,
  }

  type updateOneResult = {
    upsertedCount: int,
    upsertedId: ObjectID.t,
  }

  @send
  external stats: t => Js.Promise.t<statsResult> = "stats"

  @send
  external find: (t, {..}) => Cursor.t = "find"

  @send
  external findWithOptions: (t, {..}, {..}) => Cursor.t = "find"

  @send
  external findOne: (t, {..}) => Js.Promise.t<Js.Nullable.t<Js.Json.t>> = "findOne"

  @send
  external insertOne: (t, Js.Json.t) => Js.Promise.t<insertOneResult> = "insertOne"

  @send
  external updateOne_INTERNAL: (t, {..}, {..}) => Js.Promise.t<updateOneResult> = "updateOne"

  let updateOneWithSet = (collection, id: ObjectID.t, update: {..}): Js.Promise.t<
    updateOneResult,
  > => updateOne_INTERNAL(collection, {"_id": id}, {"$set": update})
}

module Db = {
  type t
  type collectionName = string

  @send
  external collection: (t, collectionName) => Collection.t = "collection"
}

module MongoClient = {
  type t

  @send
  external close: (t, bool) => Js.Promise.t<unit> = "close"

  @send
  external db: t => Db.t = "db"

  @send
  external dbWithName: (t, string) => Db.t = "db"
}

type connectURI = string
type connectOptions = {useUnifiedTopology: bool, useNewUrlParser: bool}

@module("mongodb") @scope("MongoClient")
external connect: (connectURI, connectOptions) => Js.Promise.t<MongoClient.t> = "connect"
