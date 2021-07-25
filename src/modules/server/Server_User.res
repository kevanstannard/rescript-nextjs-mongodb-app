open MongoDb

type dbUser = {
  _id: ObjectId.t,
  email: string,
  emailVerified: bool,
  passwordHash: string,
  created: Js.Date.t,
  updated: Js.Date.t,
  activationKey: option<string>,
  isActivated: bool,
  resetPasswordKey: option<string>,
  resetPasswordExpiry: option<Js.Date.t>,
}

let getCollection = (client: MongoClient.t) => {
  let db = MongoClient.db(client)
  Db.collection(db, "users")
}

let getStats = (client: MongoClient.t) => {
  getCollection(client)->Collection.stats
}

let hashPassword = password => {
  Bcrypt.genSaltPromise(10)->Promise.then(salt => {
    Bcrypt.hashPromise(password, salt)
  })
}

let comparePasswords = (password, passwordHash) => {
  Bcrypt.comparePromise(password, passwordHash)
}

let makeActivationKey = () => NanoId.generate()
let makeResetPasswordKey = () => NanoId.generate()
let makeEmailChangeKey = () => NanoId.generate()

let signupToDbUser = (signup: Common_User.Signup.signup): Promise.t<dbUser> => {
  let now = Js.Date.make()
  hashPassword(signup.password)->Promise.then(passwordHash => {
    let user: dbUser = {
      _id: ObjectId.make(),
      email: signup.email,
      emailVerified: false,
      passwordHash: passwordHash,
      created: now,
      updated: now,
      activationKey: Some(makeActivationKey()),
      isActivated: false,
      resetPasswordKey: None,
      resetPasswordExpiry: None,
    }
    Promise.resolve(user)
  })
}

let findUserByObjectId = (client: MongoClient.t, objectId: ObjectId.t): Promise.t<
  option<dbUser>,
> => {
  getCollection(client)
  ->Collection.findOne({"_id": objectId})
  ->Promise.thenResolve(Js.Undefined.toOption)
}

let findUserById = (client: MongoClient.t, userId: string): Promise.t<option<dbUser>> => {
  switch ObjectId.fromString(userId) {
  | Ok(userId) =>
    getCollection(client)
    ->Collection.findOne({"_id": userId})
    ->Promise.thenResolve(Js.Undefined.toOption)
  | Error(_) => Promise.resolve(None) // If parsing the object id fails, treat as a not found
  }
}

let signupUser = (client: MongoClient.t, signup: Common_User.Signup.signup) => {
  signupToDbUser(signup)->Promise.then(dbUser => {
    getCollection(client)
    ->Collection.insertOne(dbUser)
    ->Promise.then(insertResult => {
      client->findUserByObjectId(insertResult.insertedId)
    })
  })
}

let findUserByEmail = (client: MongoClient.t, email: string): Js.Promise.t<option<dbUser>> => {
  getCollection(client)
  ->Collection.findOne({"email": email})
  ->Promise.thenResolve(Js.Undefined.toOption)
}

let updateUserPassword = (client: MongoClient.t, userId: string, password: string) => {
  switch ObjectId.fromString(userId) {
  | Ok(userId) => getCollection(client)->Collection.updateOneWithSet(userId, {"password": password})
  | Error(reason) => Js.Exn.raiseError(reason) // Return rejected promise
  }
}

let updateEmailVerified = (client: MongoClient.t, userId: string, emailVerified: bool) => {
  switch ObjectId.fromString(userId) {
  | Ok(userId) =>
    getCollection(client)->Collection.updateOneWithSet(userId, {"emailVerified": emailVerified})
  | Error(reason) => Js.Exn.raiseError(reason) // Return rejected promise
  }
}
