let signup = (signup: Common_User.Signup.signup, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/signup",
    ~body=Json(signup->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}

let login = (login: Common_User.Login.login, onSuccess, onError) => {
  Client_Xhr.post(
    ~url="/api/login",
    ~body=Json(login->Common_Json.asJson),
    ~onSuccess,
    ~onError,
    (),
  )
}
