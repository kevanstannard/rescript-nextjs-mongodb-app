open MongoDb

// The dbUser should only be used in this file and not exposed to external code
type dbUser = Common_User.user<ObjectID.t>

// Alias to a commonUser for convenience
type commonUser = Common_User.commonUser

let toDbUser = (user: commonUser): result<dbUser, string> => {
  switch ObjectID.fromString(user._id) {
  | Ok(objectId) => {
      let user: dbUser = {
        _id: objectId,
        email: user.email,
        emailVerified: user.emailVerified,
        password: user.password,
      }
      Ok(user)
    }
  | Error(reason) => Error(reason)
  }
}

let toCommonUser = (user: dbUser): commonUser => {
  let user: commonUser = {
    _id: ObjectID.toString(user._id),
    email: user.email,
    emailVerified: user.emailVerified,
    password: user.password,
  }
  user
}

let getCollection = (client: MongoClient.t) => {
  let db = MongoClient.db(client)
  Db.collection(db, "users")
}

let getStats = (client: MongoClient.t) => {
  getCollection(client)->Collection.stats
}

let insertUser = (client: MongoClient.t, user: commonUser) => {
  let dbUser = toDbUser(user)
  getCollection(client)->Collection.insertOne(dbUser)
}

let findUserById = (client: MongoClient.t, userId: string): Promise.t<option<commonUser>> => {
  switch ObjectID.fromString(userId) {
  | Ok(userId) =>
    getCollection(client)
    ->Collection.findOne({"_id": userId})
    ->Promise.thenResolve(dbUser => {
      Js.Undefined.toOption(dbUser)->Belt.Option.map(toCommonUser)
    })
  | Error(_) => Promise.resolve(None) // If parsing the object id fails, treat as a not found
  }
}

let findUserByEmail = (client: MongoClient.t, email: string): Js.Promise.t<option<commonUser>> => {
  getCollection(client)
  ->Collection.findOne({"email": email})
  ->Promise.thenResolve(dbUser => {
    dbUser->Js.Undefined.toOption->Belt.Option.map(toCommonUser)
  })
}

let updateUserPassword = (client: MongoClient.t, userId: string, password: string) => {
  switch ObjectID.fromString(userId) {
  | Ok(userId) => getCollection(client)->Collection.updateOneWithSet(userId, {"password": password})
  | Error(reason) => Js.Exn.raiseError(reason)
  }
}

let updateEmailVerified = (client: MongoClient.t, userId: string, emailVerified: bool) => {
  switch ObjectID.fromString(userId) {
  | Ok(userId) =>
    getCollection(client)->Collection.updateOneWithSet(userId, {"emailVerified": emailVerified})
  | Error(reason) => Js.Exn.raiseError(reason)
  }
}
