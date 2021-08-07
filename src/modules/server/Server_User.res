open MongoDb

// TODO: Update `updated` field on all queries that change user data

type opaque
external opaque: 'a => opaque = "%identity"

module User = {
  // Note 1: Use convention of null rather than undefined for missing values.
  // Note 2: If you add or modify fields, also update the field functions below.
  type t = {
    _id: ObjectId.t,
    email: string,
    emailChange: Js.Nullable.t<string>, // May be undefined or null
    emailChangeKey: Js.Nullable.t<string>, // May be undefined or null
    emailChangeKeyExpiry: Js.Nullable.t<Js.Date.t>, // May be undefined or null
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

  let resetPasswordFields = (~resetPasswordKey: string, ~resetPasswordExpiry: Js.Date.t) =>
    {
      "resetPasswordKey": resetPasswordKey,
      "resetPasswordExpiry": resetPasswordExpiry,
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

  let emailChangeFields = (
    ~emailChange: string,
    ~emailChangeKey: string,
    ~emailChangeKeyExpiry: Js.Date.t,
  ) =>
    {
      "emailChange": emailChange,
      "emailChangeKey": emailChangeKey,
      "emailChangeKeyExpiry": emailChangeKeyExpiry,
    }

  let emailFields = (
    ~email: string,
    ~emailChange: Js.Null.t<string>,
    ~emailChangeKey: Js.Null.t<string>,
    ~emailChangeKeyExpiry: Js.Null.t<Js.Date.t>,
  ) =>
    {
      "email": email,
      "emailChange": emailChange,
      "emailChangeKey": emailChangeKey,
      "emailChangeKeyExpiry": emailChangeKeyExpiry,
    }
}

let toCommonUser = (user: User.t): Common_User.User.t => {
  id: ObjectId.toString(user._id),
  email: user.email,
  emailChange: user.emailChange->Js.Nullable.toOption,
}

let toCommonUserDto = (user: User.t): Common_User.User.dto => {
  user->toCommonUser->Common_User.User.toDto
}

let toNullCommonUserDto = (user: option<User.t>): Js.Null.t<Common_User.User.dto> => {
  switch Belt.Option.map(user, toCommonUserDto) {
  | None => Js.Null.empty
  | Some(userDto) => Js.Null.return(userDto)
  }
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

// TODO: Is this necessary?
let makeEmailChangeKeyExpiry = () => Js.Date.make()->DateFns.addHours(1)

let makeResetPasswordExpiry = () => Js.Date.make()->DateFns.addHours(1)

let signupToUser = (signup: Common_User.Signup.signup): Promise.t<User.t> => {
  let now = Js.Date.make()
  hashPassword(signup.password)->Promise.then(passwordHash => {
    let user: User.t = {
      _id: ObjectId.make(),
      email: signup.email,
      emailChange: Js.Nullable.null,
      emailChangeKey: Js.Nullable.null,
      emailChangeKeyExpiry: Js.Nullable.null,
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

let findUserByObjectId = (client: MongoClient.t, userId: ObjectId.t): Promise.t<option<User.t>> => {
  let query = User.idField(userId)
  getCollection(client)->Collection.findOne(query)->Promise.thenResolve(Js.Undefined.toOption)
}

let findUserByStringId = (client: MongoClient.t, userId: string): Promise.t<option<User.t>> => {
  let userId = ObjectId.fromString(userId)
  switch userId {
  | Error(_) => Promise.resolve(None)
  | Ok(userId) => findUserByObjectId(client, userId)
  }
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

let validateReCaptchaToken = (token: option<string>): Promise.t<
  option<Common_User.Signup.reCaptchaError>,
> => {
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
  Common_User.Signup.errors,
> => {
  let errors: Common_User.Signup.errors = Common_User.Signup.validateSignup(signup)
  switch Common_User.Signup.hasErrors(errors) {
  | true => Promise.resolve(errors)
  | false => {
      let {email, reCaptcha} = signup
      let emailTrimmed = String.trim(email)
      let emailPromise = client->validateEmailIsAvailable(emailTrimmed)
      let reCaptchaPromise = validateReCaptchaToken(reCaptcha)
      emailPromise->Promise.then(emailError => {
        reCaptchaPromise->Promise.then(reCaptchaError => {
          let errors: Common_User.Signup.errors = {
            signup: None,
            email: emailError,
            password: None,
            reCaptcha: reCaptchaError,
          }
          Promise.resolve(errors)
        })
      })
    }
  }
}

let resendActivationEmail = (
  client: MongoClient.t,
  resendActivation: Common_User.ResendActivation.resendActivation,
) => {
  client
  ->findUserByEmail(resendActivation.email)
  ->Promise.then(user => {
    switch user {
    | None => Promise.resolve(Error(#UserNotFound))
    | Some(user) => {
        let {_id, isActivated, email, activationKey} = user
        if isActivated {
          Promise.resolve(Error(#AlreadyActivated))
        } else {
          switch activationKey->Js.Null.toOption {
          | None => Js.Exn.raiseError("Activation key missing")
          | Some(activationKey) => {
              let userId = ObjectId.toString(_id)
              Server_Email.sendActivationEmail(~userId, ~email, ~activationKey)->Promise.then(_ => {
                Promise.resolve(Ok())
              })
            }
          }
        }
      }
    }
  })
}

let signup = (client: MongoClient.t, signup: Common_User.Signup.signup) => {
  validateSignup(client, signup)->Promise.then(errors => {
    if Common_User.Signup.hasErrors(errors) {
      Promise.resolve(Error(errors))
    } else {
      signupToUser(signup)
      ->Promise.then(insertUser(client))
      ->Promise.then(user => {
        let {_id, email, activationKey} = user
        switch activationKey->Js.Null.toOption {
        | None => Js.Exn.raiseError("Activation key not found after signup")
        | Some(activationKey) => {
            let userId = ObjectId.toString(_id)
            Server_Email.sendActivationEmail(
              ~userId,
              ~email,
              ~activationKey,
            )->Promise.thenResolve(_ => {
              Ok()
            })
          }
        }
      })
    }
  })
}

let login = (client: MongoClient.t, login: Common_User.Login.login) => {
  let errors = Common_User.Login.validateLogin(login)
  if Common_User.Login.hasErrors(errors) {
    Promise.resolve(Error(errors))
  } else {
    client
    ->findUserByEmail(login.email)
    ->Promise.then(user => {
      switch user {
      | None => {
          let errors: Common_User.Login.errors = {
            login: Some(#LoginFailed),
            email: None,
            password: None,
          }
          Promise.resolve(Error(errors))
        }
      | Some(user) =>
        if !user.isActivated {
          let errors: Common_User.Login.errors = {
            login: Some(#AccountNotActivated),
            email: None,
            password: None,
          }
          Promise.resolve(Error(errors))
        } else {
          comparePasswords(login.password, user.passwordHash)->Promise.then(compareResult => {
            let result = switch compareResult {
            | true => Ok(user)
            | false => {
                let errors: Common_User.Login.errors = {
                  login: Some(#LoginFailed),
                  email: None,
                  password: None,
                }
                Error(errors)
              }
            }
            Promise.resolve(result)
          })
        }
      }
    })
  }
}

let setIsActivated = (client: MongoClient.t, userId: ObjectId.t) => {
  let update = User.activationFields(~isActivated=true, ~activationKey=Js.Null.empty)
  getCollection(client)->Collection.updateOneWithSet(userId, update)
}

let activate = (client: MongoClient.t, userId: string, activationKey: string) => {
  client
  ->findUserByStringId(userId)
  ->Promise.then(user => {
    switch user {
    | None => Promise.resolve(Error(#UserNotFound))
    | Some(user) =>
      if user.isActivated {
        Promise.resolve(Ok())
      } else {
        switch user.activationKey->Js.Null.toOption {
        | None => Promise.resolve(Error(#ActivationKeyMissing))
        | Some(userActivationKey) =>
          if userActivationKey === activationKey {
            client
            ->setIsActivated(user._id)
            ->Promise.then(_updateResult => {
              Promise.resolve(Ok())
            })
          } else {
            Promise.resolve(Error(#IncorrectActivationKey))
          }
        }
      }
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
) => {
  let errors = Common_User.ChangePassword.validateChangePassword(changePassword)
  if Common_User.ChangePassword.hasErrors(errors) {
    Promise.resolve(Error(errors))
  } else {
    client
    ->findUserByObjectId(userId)
    ->Promise.then(user => {
      switch user {
      | None => {
          let errors: Common_User.ChangePassword.errors = {
            changePassword: Some(#UserNotFound),
            currentPassword: None,
            newPassword: None,
            newPasswordConfirm: None,
          }
          Promise.resolve(Error(errors))
        }
      | Some(user) =>
        if !user.isActivated {
          let errors: Common_User.ChangePassword.errors = {
            changePassword: Some(#AccountNotActivated),
            currentPassword: None,
            newPassword: None,
            newPasswordConfirm: None,
          }
          Promise.resolve(Error(errors))
        } else {
          comparePasswords(
            changePassword.currentPassword,
            user.passwordHash,
          )->Promise.then(compareResult => {
            if !compareResult {
              let errors: Common_User.ChangePassword.errors = {
                changePassword: Some(#CurrentPasswordInvalid),
                currentPassword: None,
                newPassword: None,
                newPasswordConfirm: None,
              }
              Promise.resolve(Error(errors))
            } else {
              setPassword(client, userId, changePassword.newPassword)->Promise.then(_ => {
                Promise.resolve(Ok())
              })
            }
          })
        }
      }
    })
  }
}

let setEmailChange = (
  client: MongoDb.MongoClient.t,
  userId: MongoDb.ObjectId.t,
  emailChange: string,
  emailChangeKey: string,
) => {
  let update = User.emailChangeFields(
    ~emailChange,
    ~emailChangeKey,
    ~emailChangeKeyExpiry=makeEmailChangeKeyExpiry(),
  )
  getCollection(client)->Collection.updateOneWithSet(userId, update)
}

let changeEmail = (
  client: MongoDb.MongoClient.t,
  userId: MongoDb.ObjectId.t,
  changeEmail: Common_User.ChangeEmail.changeEmail,
) => {
  let errors: Common_User.ChangeEmail.changeEmailErrors = Common_User.ChangeEmail.validateChangeEmail(
    changeEmail,
  )
  if Common_User.ChangeEmail.hasErrors(errors) {
    Promise.resolve(Error(errors))
  } else {
    client
    ->findUserByObjectId(userId)
    ->Promise.then(user => {
      switch user {
      | None => {
          let errors: Common_User.ChangeEmail.changeEmailErrors = {
            changeEmail: Some(#UserNotFound),
            email: None,
          }
          Promise.resolve(Error(errors))
        }
      | Some(user) =>
        if !user.isActivated {
          let errors: Common_User.ChangeEmail.changeEmailErrors = {
            changeEmail: Some(#AccountNotActivated),
            email: None,
          }
          Promise.resolve(Error(errors))
        } else {
          let emailTrimmed = String.trim(changeEmail.email)
          if emailTrimmed == user.email {
            let errors: Common_User.ChangeEmail.changeEmailErrors = {
              changeEmail: Some(#SameAsCurrentEmail),
              email: None,
            }
            Promise.resolve(Error(errors))
          } else {
            client
            ->checkIfEmailIsTaken(emailTrimmed)
            ->Promise.then(isTaken => {
              if isTaken {
                let errors: Common_User.ChangeEmail.changeEmailErrors = {
                  changeEmail: Some(#EmailNotAvailable),
                  email: None,
                }
                Promise.resolve(Error(errors))
              } else {
                let emailChangeKey = makeEmailChangeKey()
                client
                ->setEmailChange(userId, emailTrimmed, emailChangeKey)
                ->Promise.then(_ => {
                  let userId = ObjectId.toString(user._id)
                  Server_Email.sendEmailChangeEmail(
                    userId,
                    changeEmail.email,
                    emailChangeKey,
                  )->Promise.then(_ => {
                    let errors: Common_User.ChangeEmail.changeEmailErrors = {
                      changeEmail: None,
                      email: None,
                    }
                    Promise.resolve(Ok(errors))
                  })
                })
              }
            })
          }
        }
      }
    })
  }
}

let setEmail = (client: MongoDb.MongoClient.t, userId: MongoDb.ObjectId.t, email: string) => {
  let update = User.emailFields(
    ~email,
    ~emailChange=Js.Null.empty,
    ~emailChangeKey=Js.Null.empty,
    ~emailChangeKeyExpiry=Js.Null.empty,
  )
  getCollection(client)->Collection.updateOneWithSet(userId, update)
}

let changeEmailConfirm = (
  client: MongoDb.MongoClient.t,
  userId: string,
  emailChangeKey: string,
) => {
  client
  ->findUserByStringId(userId)
  ->Promise.then(user => {
    switch user {
    | None => Promise.resolve(Error(#UserNotFound))
    | Some(user) => {
        let currentEmailChange = Js.Nullable.toOption(user.emailChange)
        let currentEmailChangeKey = Js.Nullable.toOption(user.emailChangeKey)
        switch (currentEmailChange, currentEmailChangeKey) {
        | (None, _) => Promise.resolve(Error(#EmailChangeMissing))
        | (_, None) => Promise.resolve(Error(#EmailChangeKeyMissing))
        | (Some(currentEmailChange), Some(currentEmailChangeKey)) =>
          if currentEmailChangeKey === emailChangeKey {
            client
            ->setEmail(user._id, currentEmailChange)
            ->Promise.then(_updateResult => {
              Promise.resolve(Ok())
            })
          } else {
            Promise.resolve(Error(#IncorrectEmailChangeKey))
          }
        }
      }
    }
  })
}

let setResetPasswordKey = (
  client: MongoDb.MongoClient.t,
  userId: MongoDb.ObjectId.t,
  resetPasswordKey: string,
) => {
  let resetPasswordExpiry = makeResetPasswordExpiry()
  let update = User.resetPasswordFields(~resetPasswordKey, ~resetPasswordExpiry)
  getCollection(client)->Collection.updateOneWithSet(userId, update)
}

let forgotPassword = (
  client: MongoDb.MongoClient.t,
  forgotPassword: Common_User.ForgotPassword.forgotPassword,
) => {
  let errors = Common_User.ForgotPassword.validateForgotPassword(forgotPassword)
  if Common_User.ForgotPassword.hasErrors(errors) {
    Error(errors)->Promise.resolve
  } else {
    client
    ->findUserByEmail(forgotPassword.email)
    ->Promise.then(user => {
      switch user {
      | None => {
          let errors = {
            ...Common_User.ForgotPassword.emptyErrors(),
            forgotPassword: Some(#EmailNotFound),
          }
          Error(errors)->Promise.resolve
        }
      | Some(user) =>
        if !user.isActivated {
          let errors = {
            ...Common_User.ForgotPassword.emptyErrors(),
            forgotPassword: Some(#AccountNotActivated),
          }
          Error(errors)->Promise.resolve
        } else {
          let resetPasswordKey = makeResetPasswordKey()
          setResetPasswordKey(client, user._id, resetPasswordKey)->Promise.then(_ => {
            let userId = ObjectId.toString(user._id)
            Server_Email.sendForgotPasswordEmail(
              userId,
              user.email,
              resetPasswordKey,
            )->Promise.then(_ => {
              Promise.resolve(Ok())
            })
          })
        }
      }
    })
  }
}

let validateResetPasswordKey = (
  client: MongoClient.t,
  userId: string,
  resetPasswordKey: string,
) => {
  client
  ->findUserByStringId(userId)
  ->Promise.then(user => {
    switch user {
    | None => Promise.resolve(Error(#UserNotFound))
    | Some(user) =>
      if !user.isActivated {
        Promise.resolve(Error(#AccountNotActivated))
      } else {
        let userResetPasswordKey = Js.Null.toOption(user.resetPasswordKey)
        let userResetPasswordExpiry = Js.Null.toOption(user.resetPasswordExpiry)
        switch (userResetPasswordKey, userResetPasswordExpiry) {
        | (None, _) => Promise.resolve(Error(#ResetPasswordNotRequested))
        | (_, None) => Promise.resolve(Error(#ResetPasswordNotRequested))
        | (Some(userResetPasswordKey), Some(userResetPasswordExpiry)) =>
          if Common_Date.isInThePast(userResetPasswordExpiry) {
            Promise.resolve(Error(#ResetPasswordExpired))
          } else if userResetPasswordKey != resetPasswordKey {
            Promise.resolve(Error(#ResetPasswordKeyInvalid))
          } else {
            Promise.resolve(Ok())
          }
        }
      }
    }
  })
}

let resetPassword = (
  client: MongoDb.MongoClient.t,
  resetPassword: Common_User.ResetPassword.resetPassword,
) => {
  let userId = ObjectId.fromString(resetPassword.userId)
  switch userId {
  | Error(_) => {
      let errors: Common_User.ResetPassword.resetPasswordErrors = {
        resetPassword: Some(#ResetPasswordInvalid),
        password: None,
        passwordConfirm: None,
        reCaptcha: None,
      }
      Promise.resolve(Error(errors))
    }
  | Ok(userId) => {
      let errors = Common_User.ResetPassword.validateResetPassword(resetPassword)
      if Common_User.ResetPassword.hasErrors(errors) {
        Promise.resolve(Error(errors))
      } else {
        validateReCaptchaToken(resetPassword.reCaptcha)->Promise.then(reCaptchaError => {
          switch reCaptchaError {
          | Some(error) => {
              let errors: Common_User.ResetPassword.resetPasswordErrors = {
                resetPassword: None,
                password: None,
                passwordConfirm: None,
                reCaptcha: Some(error),
              }
              Promise.resolve(Error(errors))
            }
          | None =>
            validateResetPasswordKey(
              client,
              resetPassword.userId,
              resetPassword.resetPasswordKey,
            )->Promise.then(result => {
              switch result {
              | Error(error) => {
                  let validation: Common_User.ResetPassword.resetPasswordErrors = {
                    resetPassword: Some(
                      Common_User.ResetPassword.refineResetPasswordKeyError(error),
                    ),
                    password: None,
                    passwordConfirm: None,
                    reCaptcha: None,
                  }
                  Promise.resolve(Error(validation))
                }
              | Ok() =>
                setPassword(client, userId, resetPassword.password)->Promise.then(_ => {
                  Promise.resolve(Ok())
                })
              }
            })
          }
        })
      }
    }
  }
}
