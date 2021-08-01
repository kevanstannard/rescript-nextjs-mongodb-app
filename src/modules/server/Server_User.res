open MongoDb

type opaque
external opaque: 'a => opaque = "%identity"

module User = {
  // Note 1: Use convention of null rather than undefined for missing values.
  // Note 2: If you add or modify fields, also update the field functions below.
  type t = {
    _id: ObjectId.t,
    email: string,
    emailVerified: bool,
    emailChange: Js.Null.t<string>,
    emailChangeKey: Js.Null.t<string>,
    emailChangeKeyExpiry: Js.Null.t<Js.Date.t>,
    passwordHash: string,
    created: Js.Date.t,
    updated: Js.Date.t,
    activationKey: Js.Null.t<string>,
    isActivated: bool,
    resetPasswordKey: Js.Null.t<string>,
    resetPasswordExpiry: Js.Null.t<Js.Date.t>,
  }

  let idField = (id: ObjectId.t) => {"_id": id}

  let emailField = (email: string) => {"email": email}

  let emailQuery = (email: string) =>
    {
      "$or": [opaque({"email": email}), opaque({"emailChange": email})],
    }

  let activationFields = (~isActivated: bool, ~activationKey: Js.Null.t<string>) =>
    {
      "isActivated": isActivated,
      "activationKey": activationKey,
    }

  let passwordFields = (
    ~passwordHash: string,
    ~resetPasswordKey: Js.Null.t<string>,
    ~resetPasswordExpiry: Js.Null.t<Js.Date.t>,
  ) =>
    {
      "passwordHash": passwordHash,
      "resetPasswordKey": resetPasswordKey,
      "resetPasswordExpiry": resetPasswordExpiry,
    }
}

let toCommonUser = (user: User.t): Common_User.User.t => {
  id: ObjectId.toString(user._id),
  email: user.email,
  emailChange: user.emailChange->Js.Null.toOption,
}

let toCommonUserDto = (user: User.t): Common_User.User.dto => {
  user->toCommonUser->Common_User.User.toDto
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

let makeActivationKey = NanoId.generate
let makeResetPasswordKey = NanoId.generate
let makeEmailChangeKey = NanoId.generate

let signupToUser = (signup: Common_User.Signup.signup): Promise.t<User.t> => {
  let now = Js.Date.make()
  hashPassword(signup.password)->Promise.then(passwordHash => {
    let user: User.t = {
      _id: ObjectId.make(),
      email: signup.email,
      emailVerified: false,
      emailChange: Js.Null.empty,
      emailChangeKey: Js.Null.empty,
      emailChangeKeyExpiry: Js.Null.empty,
      passwordHash: passwordHash,
      created: now,
      updated: now,
      activationKey: Js.Null.return(makeActivationKey()),
      isActivated: false,
      resetPasswordKey: Js.Null.empty,
      resetPasswordExpiry: Js.Null.empty,
    }
    Promise.resolve(user)
  })
}

let findUserByObjectId = (client: MongoClient.t, objectId: ObjectId.t): Promise.t<
  option<User.t>,
> => {
  let query = User.idField(objectId)
  getCollection(client)->Collection.findOne(query)->Promise.thenResolve(Js.Undefined.toOption)
}

let insertUser = (client: MongoClient.t, user: User.t) => {
  getCollection(client)
  ->Collection.insertOne(user)
  ->Promise.then(insertResult => {
    client
    ->findUserByObjectId(insertResult.insertedId)
    ->Promise.then(user => {
      switch user {
      | None => Js.Exn.raiseError("User not found after insert")
      | Some(user) => Promise.resolve(user)
      }
    })
  })
}

let findUserByEmail = (client: MongoClient.t, email: string): Js.Promise.t<option<User.t>> => {
  let query = User.emailField(email)
  getCollection(client)->Collection.findOne(query)->Promise.thenResolve(Js.Undefined.toOption)
}

let checkIfEmailIsTaken = (client: MongoClient.t, email: string) => {
  getCollection(client)
  ->Collection.find(User.emailQuery(email))
  ->Cursor.toArray
  ->Promise.then((users: array<User.t>) => {
    let exists = Js.Array2.length(users) > 0
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

let validateSignup = (client: MongoClient.t, signup: Common_User.Signup.signup): Promise.t<
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

let signup = (client: MongoClient.t, signup: Common_User.Signup.signup) => {
  validateSignup(client, signup)->Promise.then(validation => {
    if Common_User.Signup.isValid(validation) {
      signupToUser(signup)
      ->Promise.then(insertUser(client))
      ->Promise.then(user => {
        let {_id, email, activationKey} = user
        switch activationKey->Js.Null.toOption {
        | None => Js.Exn.raiseError("Activation key not found after signup")
        | Some(activationKey) => {
            let userId = ObjectId.toString(_id)
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

let login = (client: MongoClient.t, login: Common_User.Login.login) => {
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

let setIsActivated = (client: MongoClient.t, userId: ObjectId.t) => {
  let update = User.activationFields(~isActivated=true, ~activationKey=Js.Null.empty)
  getCollection(client)->Collection.updateOneWithSet(userId, update)
}

let activate = (client: MongoClient.t, userId: ObjectId.t, activationKey: string) => {
  client
  ->findUserByObjectId(userId)
  ->Promise.then(user => {
    switch user {
    | Some(user) =>
      if user.isActivated {
        Promise.resolve(Ok())
      } else {
        switch user.activationKey->Js.Null.toOption {
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

let setPassword = (client: MongoClient.t, userId: ObjectId.t, password: string) => {
  password
  ->hashPassword
  ->Promise.then(passwordHash => {
    let update = User.passwordFields(
      ~passwordHash,
      ~resetPasswordKey=Js.Null.empty,
      ~resetPasswordExpiry=Js.Null.empty,
    )
    getCollection(client)->Collection.updateOneWithSet(userId, update)
  })
}

let changePassword = (
  client: MongoClient.t,
  userId: ObjectId.t,
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
