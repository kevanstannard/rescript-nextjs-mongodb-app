// MongoDB v4.4.7

// NextJS and MongoDB
// https://docs.atlas.mongodb.com/best-practices-connecting-from-aws-lambda/
// https://developer.mongodb.com/how-to/nextjs-with-mongodb/
// https://github.com/vercel/next.js/tree/canary/examples/with-mongodb

// Creating a separate node service for the API
// https://github.com/vercel/next.js/discussions/12229#discussioncomment-93027
// https://github.com/mattcarlotta/next-issg-example

module ObjectId: {
  type t
  let make: unit => t
  let toString: t => string
  let fromString: string => result<t, string>
} = {
  type t

  @module("mongodb") @new external make: unit => t = "ObjectId"

  @send external toString: t => string = "toHexString"

  // Unsafe because it can throw a runtime error
  // if the object id string is not a true ObjectId value
  @module("mongodb") @scope("ObjectId")
  external fromString_UNSAFE: string => t = "createFromHexString"

  let fromString = (value: string) => {
    try {
      Ok(fromString_UNSAFE(value))
    } catch {
    | Js.Exn.Error(obj) =>
      switch Js.Exn.message(obj) {
      | Some(reason) => Error(reason)
      | None => Error("Unknown")
      }
    | _ => Error("Unknown")
    }
  }
}

module Cursor = {
  type t

  @send external close: t => t = "close"
  @send external limit: (t, int) => t = "limit"
  @send external sort: (t, {..}) => t = "sort"
  @send external toArray: t => Js.Promise.t<array<'a>> = "toArray"
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
    acknowledged: bool,
    insertedId: ObjectId.t,
  }

  type updateOneResult = {
    upsertedCount: int,
    upsertedId: ObjectId.t,
  }

  type indexName = string

  @send external stats: t => Js.Promise.t<statsResult> = "stats"
  @send external createIndex: (t, {..}) => Promise.t<indexName> = "createIndex"
  @send external createIndexWithOptions: (t, {..}, {..}) => Promise.t<indexName> = "createIndex"
  @send external find: (t, {..}) => Cursor.t = "find"
  @send external findWithOptions: (t, {..}, {..}) => Cursor.t = "find"
  @send external findOne: (t, {..}) => Js.Promise.t<Js.Null.t<'a>> = "findOne"
  @send external insertOne: (t, 'a) => Js.Promise.t<insertOneResult> = "insertOne"
  @send external updateOne_INTERNAL: (t, {..}, {..}) => Js.Promise.t<updateOneResult> = "updateOne"

  let updateOneWithSet = (collection, id: ObjectId.t, update: {..}): Js.Promise.t<
    updateOneResult,
  > => updateOne_INTERNAL(collection, {"_id": id}, {"$set": update})
}

module Db = {
  type t
  type collectionName = string

  @send external collection: (t, collectionName) => Collection.t = "collection"
}

module MongoClient = {
  type t
  type dbName = string

  @send external close: (t, bool) => Js.Promise.t<unit> = "close"
  @send external db: t => Db.t = "db"
  @send external dbWithName: (t, dbName) => Db.t = "db"
}

type connectURI = string
type connectOptions = {useUnifiedTopology: bool, useNewUrlParser: bool}

@module("mongodb") @scope("MongoClient")
external connect: (connectURI, connectOptions) => Js.Promise.t<MongoClient.t> = "connect"
