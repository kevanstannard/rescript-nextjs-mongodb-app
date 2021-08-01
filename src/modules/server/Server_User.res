open MongoDb

type opaque
external opaque: 'a => opaque = "%identity"

type dbUser = {
  _id: ObjectId.t,
  email: string,
  emailVerified: bool,
  emailChange: option<string>,
  emailChangeKey: option<string>,
  emailChangeKeyExpiry: option<Js.Date.t>,
  passwordHash: string,
  created: Js.Date.t,
  updated: Js.Date.t,
  activationKey: option<string>,
  isActivated: bool,
  resetPasswordKey: option<string>,
  resetPasswordExpiry: option<Js.Date.t>,
}

let toCommonUser = (dbUser: dbUser): Common_User.User.t => {
  id: ObjectId.toString(dbUser._id),
  email: dbUser.email,
  emailChange: dbUser.emailChange,
}

let toCommonUserDto = (dbUser: dbUser): Common_User.User.dto => {
  dbUser->toCommonUser->Common_User.User.toDto
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
      emailChange: None,
      emailChangeKey: None,
      emailChangeKeyExpiry: None,
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

let findUserByStringId = (client: MongoClient.t, userId: string): Promise.t<option<dbUser>> => {
  switch ObjectId.fromString(userId) {
  | Ok(userId) =>
    getCollection(client)
    ->Collection.findOne({"_id": userId})
    ->Promise.thenResolve(Js.Undefined.toOption)
  | Error(_) => Promise.resolve(None) // If parsing the object id fails, treat as a not found
  }
}

let insertUser = (client: MongoClient.t, dbUser: dbUser) => {
  getCollection(client)
  ->Collection.insertOne(dbUser)
  ->Promise.then(insertResult => {
    client
    ->findUserByObjectId(insertResult.insertedId)
    ->Promise.then(dbUser => {
      switch dbUser {
      | None => Js.Exn.raiseError("User not found after insert")
      | Some(dbUser) => Promise.resolve(dbUser)
      }
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

let checkIfEmailIsTaken = (client: MongoClient.t, email: string) => {
  getCollection(client)
  ->Collection.find({
    "$or": [opaque({"email": email}), opaque({"emailChange": email})],
  })
  ->Cursor.toArray
  ->Promise.then((dbUsers: array<dbUser>) => {
    let exists = Js.Array2.length(dbUsers) > 0
    Promise.resolve(exists)
  })
}

let validateEmailIsAvailable = (client: MongoClient.t, email: string): Promise.t<
  option<Common_User.Signup.emailError>,
> => {
  let emailTrimmed = String.trim(email)
  client
  ->checkIfEmailIsTaken(emailTrimmed)
  ->Promise.then(isTaken => {
    let result = isTaken ? Some(#EmailNotAvailable) : None
    Promise.resolve(result)
  })
}

let validateReCaptchaToken = token => {
  switch token {
  | None => Promise.resolve(Some(#ReCaptchaEmpty))
  | Some(token) =>
    Server_ReCaptcha.verifyToken(token)->Promise.then(result => {
      switch result {
      | Error() => Promise.resolve(Some(#ReCaptchaInvalid))
      | Ok() => Promise.resolve(None)
      }
    })
  }
}

let validateSignup = (client: MongoDb.MongoClient.t, signup: Common_User.Signup.signup): Promise.t<
  Common_User.Signup.validation,
> => {
  let validation: Common_User.Signup.validation = Common_User.Signup.validateSignup(signup)
  switch Common_User.Signup.hasErrors(validation) {
  | true => Promise.resolve(validation)
  | false => {
      let {email, reCaptcha} = signup
      let emailTrimmed = String.trim(email)
      let emailPromise = client->validateEmailIsAvailable(emailTrimmed)
      let reCaptchaPromise = validateReCaptchaToken(reCaptcha)
      emailPromise->Promise.then(emailError => {
        reCaptchaPromise->Promise.then(reCaptchaError => {
          let validation: Common_User.Signup.validation = {
            email: emailError,
            password: None,
            reCaptcha: reCaptchaError,
          }
          Promise.resolve(validation)
        })
      })
    }
  }
}

let signup = (client: MongoDb.MongoClient.t, signup: Common_User.Signup.signup) => {
  validateSignup(client, signup)->Promise.then(validation => {
    if Common_User.Signup.isValid(validation) {
      signupToDbUser(signup)
      ->Promise.then(insertUser(client))
      ->Promise.then(dbUser => {
        let {_id, email, activationKey} = dbUser
        switch activationKey {
        | None => Js.Exn.raiseError("Activation key not found after signup")
        | Some(activationKey) => {
            let userId = MongoDb.ObjectId.toString(_id)
            Server_Email.sendActivationEmail(userId, email, activationKey)->Promise.then(_ => {
              Promise.resolve(Ok(validation))
            })
          }
        }
      })
    } else {
      Promise.resolve(Error(validation))
    }
  })
}

let login = (client: MongoDb.MongoClient.t, login: Common_User.Login.login) => {
  client
  ->findUserByEmail(login.email)
  ->Promise.then(user => {
    switch user {
    | None => Promise.resolve(Error(#UserNotFound))
    | Some(user) =>
      if !user.isActivated {
        Promise.resolve(Error(#AccountInactive))
      } else {
        comparePasswords(login.password, user.passwordHash)->Promise.then(compareResult => {
          let result = switch compareResult {
          | true => Ok(user)
          | false => Error(#PasswordInvalid)
          }
          Promise.resolve(result)
        })
      }
    }
  })
}

let setIsActivated = (client: MongoDb.MongoClient.t, userId: MongoDb.ObjectId.t) => {
  getCollection(client)->Collection.updateOneWithSet(
    userId,
    {
      "isActivated": true,
      "activationKey": Js.Null.empty,
    },
  )
}

let activate = (
  client: MongoDb.MongoClient.t,
  userId: MongoDb.ObjectId.t,
  activationKey: string,
) => {
  client
  ->findUserByObjectId(userId)
  ->Promise.then(user => {
    switch user {
    | Some(user) =>
      if user.isActivated {
        Promise.resolve(Ok())
      } else {
        switch user.activationKey {
        | None => Promise.resolve(Error(#ActivationKeyMissing))
        | Some(userActivationKey) =>
          if userActivationKey === activationKey {
            client
            ->setIsActivated(userId)
            ->Promise.then(_updateResult => {
              Promise.resolve(Ok())
            })
          } else {
            Promise.resolve(Error(#IncorrectActivationKey))
          }
        }
      }
    | None => Promise.resolve(Error(#UserNotFound))
    }
  })
}

let setPassword = (client: MongoDb.MongoClient.t, userId: MongoDb.ObjectId.t, password: string) => {
  password
  ->hashPassword
  ->Promise.then(passwordHash => {
    getCollection(client)->Collection.updateOneWithSet(
      userId,
      {
        "passwordHash": passwordHash,
        "resetPasswordKey": Js.Null.empty,
        "resetPasswordExpiry": Js.Null.empty,
      },
    )
  })
}

let changePassword = (
  client: MongoDb.MongoClient.t,
  userId: MongoDb.ObjectId.t,
  changePassword: Common_User.ChangePassword.changePassword,
): Promise.t<
  result<
    Common_User.ChangePassword.changePasswordValidation,
    Common_User.ChangePassword.changePasswordValidation,
  >,
> => {
  let validation: Common_User.ChangePassword.changePasswordValidation = Common_User.ChangePassword.validateChangePassword(
    changePassword,
  )
  if Common_User.ChangePassword.hasErrors(validation) {
    Promise.resolve(Error(validation))
  } else {
    client
    ->findUserByObjectId(userId)
    ->Promise.then(user => {
      switch user {
      | None => {
          let validation: Common_User.ChangePassword.changePasswordValidation = {
            changePassword: Some(#UserNotFound),
            currentPassword: None,
            newPassword: None,
            newPasswordConfirm: None,
          }
          Promise.resolve(Error(validation))
        }
      | Some(user) =>
        if !user.isActivated {
          let validation: Common_User.ChangePassword.changePasswordValidation = {
            changePassword: Some(#AccountNotActivated),
            currentPassword: None,
            newPassword: None,
            newPasswordConfirm: None,
          }
          Promise.resolve(Error(validation))
        } else {
          comparePasswords(
            changePassword.currentPassword,
            user.passwordHash,
          )->Promise.then(compareResult => {
            if !compareResult {
              let validation: Common_User.ChangePassword.changePasswordValidation = {
                changePassword: Some(#CurrentPasswordInvalid),
                currentPassword: None,
                newPassword: None,
                newPasswordConfirm: None,
              }
              Promise.resolve(Error(validation))
            } else {
              setPassword(client, userId, changePassword.newPassword)->Promise.then(_ => {
                Promise.resolve(Ok(validation))
              })
            }
          })
        }
      }
    })
  }
}
